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

  // HomeScreenFirebase.categoryList.forEach((element) {
  //   switch (element) {
  //   case filterState==element.songJanreCategory:
  //     print('Element is 1');
  //     break;
  //   case '2':
  //     print('Element is 2');
  //     break;
  //   case '3':
  //     print('Element is 3');
  //     break;
  //   default:
  //     print('Unknown element');
  // }
  // });
  if (filterState == '모든 곡') {
    filteredList = List.from(songListState.cast<SongItemModel>());
  } else {
    filteredList = songListState
        .cast<SongItemModel>()
        .where((element) => element.songJanre == filterState)
        .toList();
  }

  // else if (filterState == '트로트') {
  //   filteredList = songListState
  //       .cast<SongItemModel>()
  //       .where((element) => element.songJanre == '트로트')
  //       .toList();
  // } else if (filterState == '발라드') {
  //   filteredList = songListState
  //       .cast<SongItemModel>()
  //       .where((element) => element.songJanre == '발라드')
  //       .toList();
  // }
  // } else if (filterState == Jenre.CLASSIC) {
  //   filteredList = songListState
  //       .cast<SongItemModel>()
  //       .where((element) => element.songJanre == '클래식')
  //       .toList();
  // } else if (filterState == Jenre.DANCE) {
  //   filteredList = songListState
  //       .cast<SongItemModel>()
  //       .where((element) => element.songJanre == '댄스')
  //       .toList();
  // } else if (filterState == Jenre.POP) {
  //   filteredList = songListState
  //       .cast<SongItemModel>()
  //       .where((element) => element.songJanre == '팝')
  //       .toList();
  // }

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
