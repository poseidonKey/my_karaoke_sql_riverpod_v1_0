import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_provider.dart';

class SongJanreCategoryScreen extends ConsumerWidget {
  const SongJanreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songCategoryListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category 관리'),
      ),
      body: state.isEmpty
          ? const Center(
              child: Text('empty'),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(state[index].songJanreCategory),
                );
              },
              itemCount: state.length,
            ),
    );
  }
}
