import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

final favoritSongProvider = Provider.autoDispose<List<SongItemModel>>((ref) {
  final songListState = ref.watch(songItemListNotifierProvider);
  return songListState
      .where((element) => element.songFavorite == 'true')
      .toList();
});
