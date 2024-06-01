import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/google_success_screen.dart';

class AuthGoogleLoginScreen extends StatelessWidget {
  const AuthGoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onGoogleLoginPress(context),
        child: const Text('login'));
  }

  onGoogleLoginPress(BuildContext context) async {
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const GoogleSuccessScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('message : login Error')));
    }
  }
}
