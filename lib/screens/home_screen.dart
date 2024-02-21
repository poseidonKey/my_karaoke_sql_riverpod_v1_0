import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/filtered_song_list_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/random_home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getDBCount();
  }

  Future<void> getDBCount() async {
    DbHelper helper = DbHelper();
    List<SongItemModel> songList;
    List<SongItemModel> songsAllList;

    await helper.openDb();
    songsAllList = await helper.getDataAllLists();
    ref
        .read(songsAllCountProvider.notifier)
        .update((state) => songsAllList.length);
    songList = await helper.getDataAllLists();
    // songList = await helper.getDataCountLists(
    //   count: 20,
    // );
    ref.read(songCountProvider.notifier).update((state) => songList.length);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(filteredSongListProvider);
    // ref.read(songCountProvider.notifier).update((state1) => state.length);
    final count = ref.watch(songCountProvider);
    // final totalCount = ref.watch(songsAllCountProvider);
    // cnt = count;
    // final janre = ref.watch(filterProvider);
    if (state.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Like Songs'),
        actions: [
          const Text(
            '즐•찾:',
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              context.go('/home/favoritySong');
            },
            icon: const Icon(Icons.favorite),
          ),
          const Text(
            '곡찾기:',
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () async {
              context.go('/home/searchSong');
            },
            icon: const Icon(Icons.search),
          )
          // IconButton(
          //     onPressed: makeTestData, icon: const Icon(Icons.credit_card)),
          // IconButton(onPressed: deleteTestData, icon: const Icon(Icons.delete)),
        ],
      ),
      drawer: _drawer(context, ref),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  // '총 곡수 : $count 곡, $janre',
                  '총 곡수 : $count 곡,',
                  style: const TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    const Text(
                      '곡 DB : ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () {
                        context.go('/home/testDataManage');
                      },
                      icon: const Icon(Icons.add_to_queue),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 3,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: state.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 5,
                  child: Container(
                    color: Colors.grey.shade300,
                    width: 100,
                  ),
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SongItemComponent(item: state[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SongAddScreen()));
          // print(result);
          // if (result == 'success') {
          //   // await ref
          //   //     .read(songItemListNotifierProvider.notifier)
          //   //     .refreshSongsList();
          //   // print(state.length);
          //   // ref
          //   //     .read(songCountProvider.notifier)
          //   //     .update((State) => state.length + 1);
          // }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _drawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '애창곡 jangre',
              style: optionStyle,
            ),
          ),
          ListTile(
            title: const Text(
              '모든 곡',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              ref.read(filterProvider.notifier).update((state) => Janre.ALL);
              final songs = ref.read(filteredSongListProvider);
              ref.read(songCountProvider.notifier).update(
                    (state) => songs.length,
                  );
            },
          ),
          ListTile(
            title: const Text(
              '가요',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              ref
                  .read(filterProvider.notifier)
                  .update((state) => Janre.BALLADE);
              final songs = ref.read(filteredSongListProvider);
              ref.read(songCountProvider.notifier).update(
                    (state) => songs.length,
                  );
            },
          ),
          ListTile(
            title: const Text(
              '트로트',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              ref.read(filterProvider.notifier).update((state) => Janre.TROT);
              final songs = ref.read(filteredSongListProvider);
              // print(songs.length);

              ref.read(songCountProvider.notifier).update(
                    (state) => songs.length,
                  );
            },
          ),
          ListTile(
            title: const Text(
              '팝',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              ref.read(filterProvider.notifier).update((state) => Janre.POP);
              final songs = ref.read(filteredSongListProvider);
              // print(songs.length);

              ref.read(songCountProvider.notifier).update(
                    (state) => songs.length,
                  );
            },
          ),
          ListTile(
            title: const Text(
              '클래식',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              ref
                  .read(filterProvider.notifier)
                  .update((state) => Janre.CLASSIC);
              final songs = ref.read(filteredSongListProvider);

              ref.read(songCountProvider.notifier).update(
                    (state) => songs.length,
                  );
            },
          ),
          SizedBox(
            height: 30,
            child: Container(
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "category 관리",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: Container(
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "무작위 곡번호 뽑기",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RandomHomeScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
