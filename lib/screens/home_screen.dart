import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/filtered_song_list_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/random_home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_janre_category_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController controller = ScrollController();
  final List<String> popupMenu = ['즐겨찾기 화면', '곡 찾기 화면', 'DB 관리'];
  late List<SongItemCategory> categoryList;
  String janre = '모든 곡';
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
    categoryList = ref.read(songCategoryListNotifierProvider);
    getDBCount();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   myAlert(context);
  // }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      // 다음 데이터 있을 경우 추가 로딩하여 기존 데이터에 추가한다.
      print('loading');
    }
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
    // print(songList.length);
    ref.read(songCountProvider.notifier).update((state) => songList.length);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filteredSongListProvider);
    categoryList = ref.watch(songCategoryListNotifierProvider);
    // ref.read(songCountProvider.notifier).update((state1) => state.length);
    final count = ref.watch(songCountProvider);
    final janre = ref.watch(filterProviderSQL);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '애창곡 [내부데이터]',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return popupMenu
                  .map(
                    (e) => PopupMenuItem<String>(
                      value: e,
                      child: Text(e,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              if (value == '즐겨찾기 화면') {
                context.go('/home/favoritySong');
              } else if (value == 'DB 관리') {
                context.go('/home/testDataManage');
              } else {
                context.go('/home/searchSong');
              }
            },
          ),
          // const Text(
          //   '즐•찾:',
          //   style: TextStyle(
          //       fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          // ),
          // IconButton(
          //   onPressed: () {
          //     context.go('/home/favoritySong');
          //   },
          //   icon: const Icon(Icons.favorite),
          // ),
          // const Text(
          //   '곡찾기:',
          //   style: TextStyle(
          //       fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          // ),
          // IconButton(
          //   onPressed: () async {
          //     context.go('/home/searchSong');
          //   },
          //   icon: const Icon(Icons.search),
          // )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.red),
        ),
      ),
      drawer: _drawer(context, ref),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (isReversed) {
                      ref.read(sortOrderProviderSQL.notifier).state =
                          SortOrderSQL.ascending;
                    } else {
                      ref.read(sortOrderProviderSQL.notifier).state =
                          SortOrderSQL.descending;
                    }
                    isReversed = !isReversed;
                  },
                  icon: const Icon(Icons.flip_camera_android),
                  iconSize: 30,
                  tooltip: '순서바꾸기',
                ),
                Text(
                  // '총 곡수 : $count 곡, $janre',
                  '쟝르: $janre ,총 곡수 : $count 곡 ',
                  style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                // Row(
                //   children: [
                //     const Text(
                //       '곡 DB : ',
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.red,
                //           fontWeight: FontWeight.w600),
                //     ),
                //     IconButton(
                //       onPressed: () {
                //         context.go('/home/testDataManage');
                //       },
                //       icon: const Icon(Icons.add_to_queue),
                //     ),
                //   ],
                // ),
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
              child: state.isEmpty
                  ? Center(
                      child: Text(
                          '현재 ${janre.toString()}에 등록 된 곡이 없습니다.\n관리할 곡을 추가하세요.'),
                    )
                  : ListView.separated(
                      controller: controller,
                      itemCount: state.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue, Colors.green],
                            ),
                          ),
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
          context.go('/home/songAdd');
          // await Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const SongAddScreen()));
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
          categoryMenu(context: context, janreName: '모든 곡'),
          ...categoryList
              .map(
                (e) => categoryMenu(
                    context: context, janreName: e.songJanreCategory),
              )
              .toList(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SongJanreCategoryScreen(),
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
          ),
          // ElevatedButton(
          //     onPressed: () async {
          //       final datas = ref.read(songItemListNotifierProvider);
          //       for (SongItemModel item in datas) {
          //         final song = item.toMap();
          //         await FirebaseFirestore.instance
          //             .collection('songs')
          //             .doc(item.id)
          //             .set(song);
          //       }
          //     },
          //     child: const Text('fb make Data'))
        ],
      ),
    );
  }

  ListTile categoryMenu(
      {required BuildContext context, required String janreName}) {
    return ListTile(
      title: Text(
        janreName,
        style: janreName == '모든 곡'
            ? optionStyle1.copyWith(
                color: Colors.red, fontWeight: FontWeight.w700, fontSize: 23)
            : optionStyle1,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        ref.read(filterProviderSQL.notifier).update((state) => janreName);
        final songs = ref.read(filteredSongListProvider);
        ref.read(songCountProvider.notifier).update(
              (state) => songs.length,
            );
        janre = janreName;
      },
    );
  }
}
