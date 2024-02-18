import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

final songSearchNotifierProvider =
    StateNotifierProvider<SongSearchNotifier, List<SongItemModel>>(
  (ref) => SongSearchNotifier(),
);

class SongSearchNotifier extends StateNotifier<List<SongItemModel>> {
  SongSearchNotifier() : super([]) {
    final tmp = getSearchData(searchTerm: '1');
    tmp.then((value) => state = value);
  }

  Future<List<SongItemModel>> getSearchData(
      {required String searchTerm, String target = 'songName'}) async {
    DbHelper helper = DbHelper();
    List<SongItemModel> songList;

    await helper.openDb();
    songList = await helper.searchList(searchTerm, target);
    if (songList.isEmpty) {
      songList = [];
    } else {
      songList = songList;
    }
    return songList;
  }
}
