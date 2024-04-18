import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';

final songCategoryListNotifierProvider =
    StateNotifierProvider<SongCategoryListNotifier, List<SongItemCategory>>(
  (ref) => SongCategoryListNotifier(),
);

class SongCategoryListNotifier extends StateNotifier<List<SongItemCategory>> {
  SongCategoryListNotifier() : super([]) {
    final tmp = getDBData();
    tmp.then((value) => state = value);
  }

  Future<List<SongItemCategory>> getDBData() async {
    DbHelperCategory helper = DbHelperCategory();
    List<SongItemCategory> songCategoryList = [];

    await helper.openDbCategory();
    songCategoryList = await helper.getLists();
    if (songCategoryList.isEmpty) {
      songCategoryList = [];
    } else {
      state = songCategoryList;
    }

    return songCategoryList;
  }

  Future<void> getDBDataRefresh() async {
    DbHelperCategory helper = DbHelperCategory();
    List<SongItemCategory> songCategoryList = [];

    await helper.openDbCategory();
    songCategoryList = await helper.getLists();
    if (songCategoryList.isEmpty) {
      songCategoryList = [];
    } else {
      state = songCategoryList;
    }
  }
}
