import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

final songSearchNotifierProvider =
    StateNotifierProvider.autoDispose<SongSearchNotifier, List<SongItemModel>>(
  (ref) => SongSearchNotifier(),
);

class SongSearchNotifier extends StateNotifier<List<SongItemModel>> {
  SongSearchNotifier() : super([]) {
    // final tmp = getSearchData(searchValue: '1');
    // tmp.then((value) => state = value);
  }

  Future<List<SongItemModel>> getSearchData(
      {required String searchValue, String target = 'songName'}) async {
    DbHelper helper = DbHelper();
    List<SongItemModel> songList;

    await helper.openDb();
    songList = await helper.searchList(searchValue, target);
    if (songList.isEmpty) {
      songList = [];
    } else {
      songList = songList;
    }
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
