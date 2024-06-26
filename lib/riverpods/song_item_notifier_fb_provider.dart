import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/song_count.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final songListFirebaseProvider =
    StateNotifierProvider<SongItemNotifierFb, List<SongItemModel?>>((ref) {
  return SongItemNotifierFb();
});

class SongItemNotifierFb extends StateNotifier<List<SongItemModel?>> {
  SongItemNotifierFb() : super([]) {
    final tmp = fetchSongDataAndSortByNo();
    tmp.then((value) {
      state = value;
    });
  }

  Future<List<SongItemModel?>> fetchSongDataAndSortByNo() async {
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
    // data.sort((a, b) => (a.id!).compareTo(b.id!));
    data.sort((a, b) => (int.parse(a.id!)).compareTo(int.parse(b.id!)));
    SongCount.songsCountFB = data.length;

    return data;
  }

  Future<void> refreshSongDataAndSortByNo() async {
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
    // data.sort((a, b) => (a.id!).compareTo(b.id!));
    data.sort((a, b) => (int.parse(a.id!)).compareTo(int.parse(b.id!)));
    state = data;
  }

  List<SongItemModel> favChangeSongItem({
    required String id,
  }) {
    state.map((element) {
      (element!.id == id)
          ? element.copyWith(
              songFavorite: (element.songFavorite == 'true')
                  ? element.songFavorite = 'false'
                  : element.songFavorite = 'true')
          : element;
    }).toList();
    return state.cast();
  }

  void removeItem(int index) async {
    state.removeAt(index);
  }

  void undoRemoveItem(int index, SongItemModel item) async {
    state.insert(index, item);
    state = await fetchSongDataAndSortByNo();
  }
}
