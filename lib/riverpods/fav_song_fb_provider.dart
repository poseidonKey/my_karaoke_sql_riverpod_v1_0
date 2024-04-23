import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';

final favoritSongFirebaseProvider =
    Provider.autoDispose<List<SongItemModel?>>((ref) {
  final songListState = ref.watch(songListFirebaseProvider);
  return songListState
      .where((element) => element!.songFavorite == 'true')
      .toList();
});
