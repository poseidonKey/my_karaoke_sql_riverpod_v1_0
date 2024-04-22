import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';

final filterFirebaseProvider = StateProvider((ref) => Jenre.ALL);

final filteredSongListFirebaseProvider = Provider<List<SongItemModel>>((ref) {
  final songListState = ref.watch(songListFirebaseProvider);
  final filterState = ref.watch(filterFirebaseProvider);
  final sortOrder =
      ref.watch(sortOrderProvider); // New state variable for sort order
  List<SongItemModel> filteredList = [];

  if (filterState == Jenre.ALL) {
    filteredList = List.from(songListState.cast<SongItemModel>());
  } else if (filterState == Jenre.TROT) {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == '트로트')
        .toList();
  } else if (filterState == Jenre.BALLADE) {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == '발라드')
        .toList();
  } else if (filterState == Jenre.CLASSIC) {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == '클래식')
        .toList();
  } else if (filterState == Jenre.DANCE) {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == '댄스')
        .toList();
  } else if (filterState == Jenre.POP) {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == '팝')
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



// final filteredSongListFirebaseProvider = Provider<List<SongItemModel>>((ref) {
//   final songListState = ref.watch(songListFirebaseProvider);
//   final filterState = ref.watch(filterFirebaseProvider);
//   if (filterState == Jenre.ALL) {
//     return songListState.cast<SongItemModel>();
//   }
//   if (filterState == Jenre.TROT) {
//     return songListState
//         .cast<SongItemModel>()
//         .where((element) => element.songJanre == '트로트')
//         .toList();
//   }

//   if (filterState == Jenre.BALLADE) {
//     return songListState
//         .cast<SongItemModel>()
//         .where((element) => element.songJanre == '발라드')
//         .toList();
//   }
//   if (filterState == Jenre.CLASSIC) {
//     return songListState
//         .cast<SongItemModel>()
//         .where((element) => element.songJanre == '클래식')
//         .toList();
//   }
//   if (filterState == Jenre.DANCE) {
//     return songListState
//         .cast<SongItemModel>()
//         .where((element) => element.songJanre == '댄스')
//         .toList();
//   }
//   if (filterState == Jenre.POP) {
//     return songListState
//         .cast<SongItemModel>()
//         .where((element) => element.songJanre == '팝')
//         .toList();
//   } else {
//     return [];
//   }
// });
