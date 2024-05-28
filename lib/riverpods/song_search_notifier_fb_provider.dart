import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final songSearchNotifierFBProvider = StateNotifierProvider.autoDispose<
    SongSearchNotifierFB, List<SongItemModel>>(
  (ref) => SongSearchNotifierFB(),
);

class SongSearchNotifierFB extends StateNotifier<List<SongItemModel>> {
  SongSearchNotifierFB() : super([]) {
    // final tmp = getSearchData(searchValue: '1');
    // tmp.then((value) => state = value);
  }

  Future<List<SongItemModel>> getSearchData(
      {required String searchValue, String target = 'songName'}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('UID');
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await MyFirebaseService.instance.doc(uid).collection('songs').get();
    // await FirebaseFirestore.instance.collection('songs').get();
    List<SongItemModel> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            SongItemModel.fromSnapshot(snapshot))
        .toList();
    List<SongItemModel> songList;
    songList = data
        .where(
          (model) => model.songName.contains(searchValue),
        )
        .toList();

    return songList;
  }

  void getSearchDataList(
      {required List<SongItemModel> state1,
      required String searchValue,
      String target = 'songName'}) {
    List<SongItemModel> songList;
    print(searchValue);
    print(state1);
    songList =
        state.where((item) => item.songName.contains(searchValue)).toList();
    state = songList;
    print(songList);
  }
}
