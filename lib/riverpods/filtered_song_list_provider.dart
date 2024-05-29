import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

enum SortOrderSQL { ascending, descending }

final sortOrderProviderSQL =
    StateProvider<SortOrderSQL>((ref) => SortOrderSQL.ascending);

final filterProviderSQL = StateProvider((ref) => '모든 곡');

final filteredSongListProvider = Provider<List<SongItemModel>>((ref) {
  // final songListState = ref.watch(songItemListNotifierProviderDB).value;
  final songListState = ref.watch(songItemListNotifierProvider);
  final filterState = ref.watch(filterProviderSQL);
  List<SongItemModel> filteredList = [];
  final sortOrderSQL = ref.watch(sortOrderProviderSQL);

  if (filterState == '모든 곡') {
    filteredList = List.from(songListState.cast<SongItemModel>());
  } else {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == filterState)
        .toList();
  }

  if (sortOrderSQL == SortOrderSQL.ascending) {
    filteredList.sort((a, b) => (int.parse(a.id!)).compareTo(int.parse(b.id!)));
  } else {
    filteredList.sort((a, b) => (int.parse(b.id!)).compareTo(int.parse(a.id!)));
  }

  return filteredList;

  // if (filterState == Jenre.ALL) {
  //   return songListState;
  // }
  // if (filterState == Jenre.TROT) {
  //   return songListState
  //       .where((element) => element.songJanre == '트로트')
  //       .toList();
  // }

  // if (filterState == Jenre.BALLADE) {
  //   return songListState
  //       .where((element) => element.songJanre == '발라드')
  //       .toList();
  // }
  // if (filterState == Jenre.CLASSIC) {
  //   return songListState
  //       .where((element) => element.songJanre == '클래식')
  //       .toList();
  // }
  // if (filterState == Jenre.DANCE) {
  //   return songListState.where((element) => element.songJanre == '댄스').toList();
  // }
  // if (filterState == Jenre.POP) {
  //   return songListState.where((element) => element.songJanre == '팝').toList();
  // } else {
  //   return [];
  // }
});
