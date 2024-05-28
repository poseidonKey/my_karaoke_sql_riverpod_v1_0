import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('UID');
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await MyFirebaseService
        .instance
        .doc(uid)
        .collection('songCategoris')
        .get();
    List<SongItemCategory> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            SongItemCategory.fromSnapshot(snapshot))
        .toList();
    data.sort((a, b) => (a.id!).compareTo(b.id!));
    return data;
  }

  Future<void> getDBDataFirebaseRefresh() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('UID');
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await MyFirebaseService
        .instance
        .doc(uid)
        .collection('songCategoris')
        .get();
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
