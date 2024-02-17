import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/fav_song_provider.dart';

class FavoritySongScreen extends ConsumerWidget {
  const FavoritySongScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritSongProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 목록'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return SongItemComponent(
            item: state[index],
          );
        },
        itemCount: state.length,
      ),
    );
  }
}
