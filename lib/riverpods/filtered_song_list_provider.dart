import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';

final filteredSongListProvider = Provider<List<SongItemModel>>((ref) {
  final songListState = ref.watch(songItemListNotifierProviderDB).value;
  final filterState = ref.watch(filterProvider);
  if (filterState == Janre.ALL) return songListState!;
  if (filterState == Janre.TROT) {
    return songListState!
        .where((element) => element.songJanre == '트로트')
        .toList();
    // final songs =
    //     songListState!.where((element) => element.songJanre == '트로트').toList();
    // ref.read(songCountProvider.notifier).update(
    //       (state) => songs.length,
    //     );
    // return songListState;
  }
  if (filterState == Janre.BALLADE) {
    return songListState!
        .where((element) => element.songJanre == '가요')
        .toList();
  }
  if (filterState == Janre.CLASSIC) {
    return songListState!
        .where((element) => element.songJanre == '클래식')
        .toList();
  }
  if (filterState == Janre.DANCE) {
    return songListState!
        .where((element) => element.songJanre == '댄스')
        .toList();
  }

  return [];
});

final filterProvider = StateProvider((ref) => Janre.ALL);
