import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component_fb_onlyView.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/fav_song_fb_provider.dart';

class FavoritySongFirebaseScreen extends ConsumerWidget {
  const FavoritySongFirebaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritSongFirebaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 목록 :FB'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return state[index] != null
              ? SongItemComponentFirebaseOnlyView(
                  index: int.parse(state[index]!.id!),
                  item: state[index]!,
                )
              : Container();
        },
        itemCount: state.length,
      ),
    );
  }
}
