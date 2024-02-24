import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

final filterProvider = StateProvider((ref) => Janre.ALL);

final filteredSongListProvider = Provider<List<SongItemModel>>((ref) {
  // final songListState = ref.watch(songItemListNotifierProviderDB).value;
  final songListState = ref.watch(songItemListNotifierProvider);
  final filterState = ref.watch(filterProvider);
  if (filterState == Janre.ALL) {
    return songListState;
  }
  if (filterState == Janre.TROT) {
    return songListState
        .where((element) => element.songJanre == '트로트')
        .toList();
  }

  if (filterState == Janre.BALLADE) {
    return songListState
        .where((element) => element.songJanre == '발라드')
        .toList();
  }
  if (filterState == Janre.CLASSIC) {
    return songListState
        .where((element) => element.songJanre == '클래식')
        .toList();
  }
  if (filterState == Janre.DANCE) {
    return songListState.where((element) => element.songJanre == '댄스').toList();
  }
  if (filterState == Janre.POP) {
    return songListState.where((element) => element.songJanre == '팝').toList();
  } else {
    return [];
  }
});
