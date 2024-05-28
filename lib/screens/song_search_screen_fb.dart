import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/default_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_search_notifier_fb_provider.dart';

class SongSearchScreenFirebase extends ConsumerWidget {
  TextEditingController controller = TextEditingController();
  String search = '';
  SongSearchScreenFirebase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songSearchNotifierFBProvider);
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
                    List<SongItemModel> songList = [];
                    final data = ref.read(songListFirebaseProvider);
                    final result = data
                        .where((element) =>
                            element?.songName.toLowerCase().contains(search) ??
                            false)
                        .toList();
                    songList = result.cast<SongItemModel>();
                    ref.read(songSearchNotifierFBProvider.notifier).state =
                        songList;
                  },
                  child: const Text('등록 된 곡 중 찾기'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('이전 화면으로'),
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
