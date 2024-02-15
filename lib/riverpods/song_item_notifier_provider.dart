import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

final songItemListNotifierProvider =
    FutureProvider<List<SongItemModel>>((ref) async {
  DbHelper helper = DbHelper();
  List<SongItemModel> songList;

  await helper.openDb();
  songList = await helper.getLists();
  if (songList.isEmpty) {
    songList = [];
  } else {
    songList = songList;
  }
  return songList;
});
// final songItemListNotifierProvider =
//     StateNotifierProvider<SongItemNotifier, List<SongItemModel>>(
//   (ref) => SongItemNotifier(),
// );

class SongItemNotifier extends StateNotifier<List<SongItemModel>> {
  SongItemNotifier() : super([]);
}
