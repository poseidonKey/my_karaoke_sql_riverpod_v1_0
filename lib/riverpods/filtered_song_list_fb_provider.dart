import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';

final filterFirebaseProvider = StateProvider<String>((ref) => '모든 곡');

final filteredSongListFirebaseProvider = Provider<List<SongItemModel>>((ref) {
  final songListState = ref.watch(songListFirebaseProvider);
  final filterState = ref.watch(filterFirebaseProvider);
  final sortOrder =
      ref.watch(sortOrderProvider); // New state variable for sort order
  List<SongItemModel> filteredList = [];

  if (filterState == '모든 곡') {
    filteredList = List.from(songListState.cast<SongItemModel>());
  } else {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == filterState)
        .toList();
  }

  // Sort the filtered list based on the song id and sortOrder
  if (sortOrder == SortOrder.ascending) {
    filteredList.sort((a, b) => (int.parse(a.id!)).compareTo(int.parse(b.id!)));
  } else {
    filteredList.sort((a, b) => (int.parse(b.id!)).compareTo(int.parse(a.id!)));
  }

  return filteredList;
});

// Define a state provider for sort order
enum SortOrder { ascending, descending }

final sortOrderProvider =
    StateProvider<SortOrder>((ref) => SortOrder.ascending);
