import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';

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
  // List<SongItemModel> songData = ref.read(songItemListNotifierProvider);
  // songData.clear();
  // songData.addAll(songList);
  ref.read(songCountProvider.notifier).update(
        (state) => songList.length,
      );
  return songList;
});

final songItemListNotifierProvider =
    StateNotifierProvider<SongItemNotifier, List<SongItemModel>>(
  (ref) => SongItemNotifier(),
);

class SongItemNotifier extends StateNotifier<List<SongItemModel>> {
  SongItemNotifier() : super([]);

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
