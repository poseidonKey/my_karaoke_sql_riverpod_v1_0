import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/defaut_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_search_notifier_provider.dart';

class SongSearchScreen extends ConsumerWidget {
  const SongSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songSearchNotifierProvider);
    return DefaultLayout(
      title: '곡 찾기',
      body: Column(
        children: [
          TextFormField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  DbHelper helper = DbHelper();
                  await helper.openDb();
                  final songList = await helper.searchList('1', 'songName');
                  print(songList);
                },
                child: const Text('Search'),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.length,
              itemBuilder: (BuildContext context, int index) {
                // final item = songList![index];
                return ListTile(
                  title: GestureDetector(
                    child: Text(state[index].songName),
                    onTap: () async {
                      context.pop();
                    },
                  ),
                  leading: CircleAvatar(
                    radius: 15,
                    foregroundColor: Colors.deepPurpleAccent,
                    child: Text(
                      state[index].id!,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
