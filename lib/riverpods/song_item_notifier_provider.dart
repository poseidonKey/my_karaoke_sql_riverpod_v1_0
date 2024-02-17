import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';

final songItemListNotifierProvider =
    StateNotifierProvider<SongItemNotifier, List<SongItemModel>>(
  (ref) => SongItemNotifier(),
);

class SongItemNotifier extends StateNotifier<List<SongItemModel>> {
  SongItemNotifier() : super([]) {
    final tmp = getDBData();
    tmp.then((value) => state = value);
    // state = getDBData() as List<SongItemModel>;
  }

  Future<List<SongItemModel>> getDBData() async {
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
  }

  List<SongItemModel> favChangeSongItem({
    required String id,
  }) {
    state.map((element) {
      (element.id == id)
          ? element.copyWith(
              songFavorite: (element.songFavorite == 'true')
                  ? element.songFavorite = 'false'
                  : element.songFavorite = 'true')
          : element;
    }).toList();
    return state;
  }
}

final songItemListNotifierProviderDB =
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

  ref.read(songCountProvider.notifier).update(
        (state) => songList.length,
      );
  return songList;
});
