import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/defaut_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_search_notifier_provider.dart';

class SongSearchScreen extends ConsumerWidget {
  TextEditingController controller = TextEditingController();
  String search = '';
  SongSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songSearchNotifierProvider);
    return DefaultLayout(
      title: '곡 찾기',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              onChanged: (value) {
                search = value;
              },
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              //// 내일 가을
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    List<SongItemModel> songList;
                    // List<SongItemModel> totalSongList;
                    songList = ref
                        .read(songItemListNotifierProvider.notifier)
                        .state
                        .where((item) => item.songName.contains(search))
                        .toList();
                    ref.read(songSearchNotifierProvider.notifier).state =
                        songList;
                  },
                  child: const Text('등록 된 곡 중 찾기'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('메인 화면으로'),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.length,
                itemBuilder: (BuildContext context, int index) {
                  // final item = songList![index];
                  return ListTile(
                    title: Text(state[index].songName),
                    leading: CircleAvatar(
                      radius: 15,
                      foregroundColor: Colors.deepPurpleAccent,
                      child: Text(
                        state[index].id!,
                      ),
                    ),
                    trailing: Text(
                      '장르 : [${state[index].songJanre}]',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
