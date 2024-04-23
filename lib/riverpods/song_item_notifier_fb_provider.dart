import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

final songListFirebaseProvider =
    StateNotifierProvider<SongItemNotifierFb, List<SongItemModel?>>(
  (ref) => SongItemNotifierFb(),
);

class SongItemNotifierFb extends StateNotifier<List<SongItemModel?>> {
  SongItemNotifierFb() : super([]) {
    final tmp = fetchSongDataAndSortByNo();
    tmp.then((value) => state = value);
  }

  Future<List<SongItemModel?>> fetchSongDataAndSortByNo() async {
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('songs').get();
    List<SongItemModel> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            SongItemModel.fromSnapshot(snapshot))
        .toList();
    // data.sort((a, b) => (a.id!).compareTo(b.id!));
    data.sort((a, b) => (int.parse(a.id!)).compareTo(int.parse(b.id!)));
    return data;
  }

  Future<void> refreshSongDataAndSortByNo() async {
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('songs').get();
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
