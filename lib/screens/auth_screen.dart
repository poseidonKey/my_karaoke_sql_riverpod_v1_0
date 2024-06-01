import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/login_text_field.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/uid_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/sql_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userId = '';
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
    userCheck();
  }

  void userCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? 'no User';
    if (userId != 'no User') {
      context.go('/home_fb');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      child: Image.asset(
                        'assets/img/logo.png',
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  LoginTextField(
                    controller: emailController,
                    focusNode: _emailFocusNode,
                    onSaved: (val) {
                      email = val!;
                    },
                    validator: (val) {
                      if (val?.isEmpty ?? true) {
                        return '이메일을 입력해주세요.';
                      }

                      RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!reg.hasMatch(val!)) {
                        return '이메일 형식이 올바르지 않습니다.';
                      }
                      return null;
                    },
                    hintText: '이메일',
                  ),
                  const SizedBox(height: 8.0),
                  LoginTextField(
                    focusNode: _passwordFocusNode,
                    controller: passwordController,
                    onSaved: (val) {
                      password = val!;
                    },
                    obscureText: true,
                    validator: (val) {
                      if (val?.isEmpty ?? true) {
                        return '비밀번호를 입력해주세요.';
                      }

                      if (val!.length < 4 || val.length > 8) {
                        return '비밀번호는 4~8자 사이로 입력 해주세요!';
                      }
                      return null;
                    },
                    hintText: '비밀번호',
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: SECONDARY_COLOR,
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (saveAndValidateForm()) {
                        _register();
                      } else {
                        print('error occure');
                      }
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: SECONDARY_COLOR,
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      // email=formKey.
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (saveAndValidateForm()) {
                        // Obtain shared preferences.
                        // final userPasswd = prefs.get('userPasswd');

                        final uid = await signIn();
                        if (uid != null) {
                          await prefs.setString('userId', email);
                          await prefs.setString('passwd', password);
                          await prefs.setString('UID', uid);
                          ref.read(uidProvider.notifier).state = uid;
                        }
                        context.go('/home_fb');
                      } else {
                        print('error occure');
                      }
                    },
                    child: const Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      context.go('/home');
                    },
                    child: const Text(
                      '내장 SQL 이용',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  InkWell(
                    onTap: () async {
                      await onGoogleLoginPressMy(context);
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img/google.png',
                            width: 50,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Sign In With Google',
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SqlTest(),
                        ),
                      );
                    },
                    child: const Text(
                      'SQL Test',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      // email=formKey.
                      // final SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // if (saveAndValidateForm()) {
                      //   // Obtain shared preferences.
                      //   // final userPasswd = prefs.get('userPasswd');

                      //   await prefs.setString('userId', email);
                      //   final uid = await signIn();
                      //   if (uid != null) {
                      //     await prefs.setString('UID', uid);
                      //     ref.read(uidProvider.notifier).state = uid;
                      //   }
                      //   context.go('/home_fb');
                      // } else {
                      //   print('error occure');
                      // }
                    },
                    child: const Text(
                      'firebase 이용',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // FilledButton(
                  //   onPressed: _moveData,
                  //   child: const Text('FB 데이터 옮기기'),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    return true;
  }

  onGoogleLoginPressMy(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      print(account?.email);
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', email);
      await prefs.setString('passwd', password);
      await prefs.setString('UID', uid);
      ref.read(uidProvider.notifier).state = uid;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('정보!'),
              content: const Text('이전 로그인 정보로 실행될 수 있습니다.\n앱을 종료 후 재 실행하세요.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/home_fb');
                    },
                    child: const Text('Close'))
              ]);
        },
      );

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => Container(),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('message : login Error'),
        ),
      );
    }
  }

  Future<void> _moveData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final state = ref.read(uidProvider);
    try {
      QuerySnapshot querySnapshot = await firestore.collection('songs').get();
      // await firestore.collection('allSongs').doc('').set(querySnapshot);
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        await firestore
            .collection('allSongs')
            .doc(state)
            .collection('songs')
            .doc(data['id'])
            .set(data);
      }
      querySnapshot = await firestore.collection('songCategoris').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        await firestore
            .collection('allSongs')
            .doc(state)
            .collection('songCategoris')
            .doc(data['id'])
            .set(data);

        // await firestore
        //     .collection('test')
        //     .doc(doc.id)
        //     .delete(); // 원본 데이터를 삭제하고 싶으면 이 줄을 추가합니다.
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('message : Success Data Move'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _register() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Registered: ${userCredential.user?.uid}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('가입 완료'),
              content: const Text('회원가입 되었습니다.\n가입 email로 로그인 하세요!'),
              actions: [
                TextButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();
                      _emailFocusNode.requestFocus();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'))
              ]);
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('이미 사용자 계정이 있습니다.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('가입 오류'),
                content: const Text('이미 사용자 계정이 있습니다.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        emailController.clear();
                        passwordController.clear();
                        _emailFocusNode.requestFocus();
                        Navigator.of(context).pop();
                      },
                      child: const Text('확인!'))
                ]);
          },
        );
      } else {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    }
  }

  Future<String?> signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password,
        // email: 'jsy@jsy.com',
        // password: 'jsy1030',
        // email: 'test@jsy.com',
        // password: 'testtest',
      );
      print('Signed in: ${userCredential.user?.uid}');

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('인증 오류'),
              content: Text('오류가 발생했습니다.\n ${e.message} '),
              actions: [
                TextButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();
                      _emailFocusNode.requestFocus();
                      Navigator.of(context).pop();
                    },
                    child: const Text('확인!'))
              ]);
        },
      );
    }
    return null;
  }
}
