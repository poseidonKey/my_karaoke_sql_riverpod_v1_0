import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

final filteredSongListProvider = Provider<List<SongItemModel>>((ref) {
  final songListState = ref.watch(songItemListNotifierProviderDB);
  final filterState = ref.watch(filterProvider);
  if (filterState == Janre.ALL) return songListState.value!;
  return [];
  // return songListState.value!.where((element) {
  //   switch (element.songJanre) {
  //     case '발라드':
  //       return filterState == Janre.BALLADE;

  //     default:
  //   }

  // if (element.songJanre == Janre.BALLADE) {
  //   return filterState == Janre.BALLADE;
  // } else {
  //   return true;
  // }
  // }).toList();
  // return songListState.w
  // return [];
});

final filterProvider = StateProvider((ref) => Janre.ALL);
