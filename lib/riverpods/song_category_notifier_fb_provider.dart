import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';

final songCategoryListNotifierFirebaseProvider = StateNotifierProvider<
    SongCategoryListFirebaseNotifier, List<SongItemCategory>>(
  (ref) => SongCategoryListFirebaseNotifier(),
);

class SongCategoryListFirebaseNotifier
    extends StateNotifier<List<SongItemCategory>> {
  SongCategoryListFirebaseNotifier() : super([]) {
    final tmp = getDBFirebaseData();
    tmp.then((value) => state = value);
  }

  Future<List<SongItemCategory>> getDBFirebaseData() async {
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('songCategoris').get();
    List<SongItemCategory> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            SongItemCategory.fromSnapshot(snapshot))
        .toList();
    data.sort((a, b) => (a.id!).compareTo(b.id!));
    return data;
  }

  Future<void> getDBDataFirebaseRefresh() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('songCategoris').get();
    List<SongItemCategory> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            SongItemCategory.fromSnapshot(snapshot))
        .toList();
    data.sort((a, b) => (a.id!).compareTo(b.id!));
    if (data.isNotEmpty) {
      state = data;
    }
  }
}
