import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/default_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/uid_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';

class SongAddScreenFirebase extends ConsumerStatefulWidget {
  const SongAddScreenFirebase({super.key});

  @override
  ConsumerState<SongAddScreenFirebase> createState() => _SongAddScreenState();
}

class _SongAddScreenState extends ConsumerState<SongAddScreenFirebase> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? _songName, _songGYNumber, _songTJNumber, _songUtubeAddress, _songETC;
  final String _songFavorite = "false";
  String _selJanre = "곡 쟝르를 선택하세요!";
  @override
  Widget build(BuildContext context) {
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categories = ref.watch(songCategoryListNotifierFirebaseProvider);
    List<String> cateList = [];
    for (var element in categories) {
      cateList.add(element.songJanreCategory);
    }
    return DefaultLayout(
      title: '곡 추가',
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(
                FocusNode(),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    30.0,
                    20.0,
                    30.0,
                    10.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '곡명',
                    ),
                    validator: (val) =>
                        val!.trim().isEmpty ? '곡명은 필수 입니다.' : null,
                    onSaved: (val) => _songName = val,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '금영노래방 번호',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    // validator: (val) =>
                    //     val!.trim().isEmpty ? '금영노래방 번호는 필수입니다' : null,
                    onSaved: (val) => _songGYNumber = val ?? "",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '태진노래방 번호',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSaved: (val) => _songTJNumber = val ?? "",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _selJanre,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                        items: cateList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? value) {
                          print('touch');
                          setState(() {
                            _selJanre = value ?? "";
                          });
                        },
                        icon: const Icon(Icons.pin_drop),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '관련 유튜브 주소',
                    ),
                    onSaved: (val) => _songUtubeAddress = val ?? "",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '특기사항',
                    ),
                    maxLines: 2,
                    onSaved: (val) => _songETC = val ?? "",
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => submit("add"),
                      child: const Text(
                        'Add Song',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     String collectionName =
                //         'songs'; // Replace with the actual collection name
                //     DocumentSnapshot? document =
                //         await findDocumentWithHighestId(collectionName);

                //     if (document != null) {
                //       print('Document with the highest ID: ${document.id}');
                //       print('Document data: ${document.data()}');
                //     } else {
                //       print('No documents found in the collection.');
                //     }
                //   },
                //   child: const Text(
                //     'Max ID Test',
                //     style: TextStyle(fontSize: 20.0),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit(String mode) async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    int id;
    try {
      String collectionName =
          'songs'; // Replace with the actual collection name
      DocumentSnapshot? document =
          await findDocumentWithHighestId(collectionName);

      if (document != null) {
        id = int.parse(document.id) + 1;
      } else {
        id = 1;
      }
      _songUtubeAddress =
          'https://www.google.com/search?q=%EB%88%88%EC%9D%B4%EB%82%B4%EB%A6%AC%EB%84%A4+mr&rlz=1C5CHFA_enKR1089KR1089&oq=%EB%88%88%EC%9D%B4%EB%82%B4%EB%A6%AC%EB%84%A4+mr&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRigATIHCAIQIRigAdIBCTEyNTgyajBqN6gCALACAA&sourceid=chrome&ie=UTF-8#vhid=_MoZ4NyKkE2o7M&vssid=global';
      final newSong = SongItemModel(
          id.toString(),
          _songName!,
          _songGYNumber!,
          _songTJNumber!,
          _selJanre,
          _songUtubeAddress!,
          _songETC ?? '가사나 기타 참고사항 기록',
          "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}",
          _songFavorite);
      final newSongJson = newSong.toMap();

      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final uid = prefs.getString('UID');
      final uid = ref.read(uidProvider);
      MyFirebaseService.instance
          .doc(uid)
          .collection('songs')
          .doc(id.toString())
          .set(newSongJson);

      await ref
          .read(songListFirebaseProvider.notifier)
          .refreshSongDataAndSortByNo();
      // await ref.read(songItemListNotifierProvider.notifier).refreshSongsList();
      // final List<SongItemModel> songCnt =
      //     ref.read(songItemListNotifierProvider);
      // ref.read(songCountProvider.notifier).update((State) => songCnt.length);
      // Navigator.pop(context, 'success');
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot?> findDocumentWithHighestId(
      String collectionName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final uid = ref.read(uidProvider);
    // print(uid);

    // Query all documents in the collection
    QuerySnapshot snapshot = await firestore
        .collection('allSongs')
        .doc(uid)
        .collection(collectionName)
        .get();

    // Initialize variables to keep track of the highest ID and the corresponding document
    int? maxId;
    DocumentSnapshot? documentWithMaxId;

    // Loop through each document to find the one with the highest ID
    for (DocumentSnapshot document in snapshot.docs) {
      // Extract the document ID
      int id = int.tryParse(document.id) ?? 0;

      // Check if the current ID is higher than the previous maximum
      if (maxId == null || id > maxId) {
        maxId = id;
        documentWithMaxId = document;
      }
    }

    // Return the document with the highest ID (or null if no documents are found)
    return documentWithMaxId;
  }
}
