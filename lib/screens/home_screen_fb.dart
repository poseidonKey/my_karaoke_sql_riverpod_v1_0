import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/song_count.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/filtered_song_list_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/random_home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_janre_category_fb_screen.dart';

class HomeScreenFirebase extends ConsumerStatefulWidget {
  const HomeScreenFirebase({super.key});

  @override
  ConsumerState<HomeScreenFirebase> createState() => _HomeScreenFirebaseState();
}

class _HomeScreenFirebaseState extends ConsumerState<HomeScreenFirebase> {
  final ScrollController controller = ScrollController();
  final List<String> popupMenu = ['즐겨찾기 화면', '곡 찾기 화면', 'DB 관리'];
  late List<SongItemCategory> categoryList;
  bool isAlert = true;
  int sub = 0;

  String janre = '모든 곡';
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
    categoryList = ref.read(songCategoryListNotifierFirebaseProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    songAlert();
  }

  void songAlert() async {
    DbHelper helper = DbHelper();

    await helper.openDb();
    await helper.getDataAllLists();
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      // 다음 데이터 있을 경우 추가 로딩하여 기존 데이터에 추가한다.
      print('loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filteredSongListFirebaseProvider);
    final count = state.length;
    if (SongCount.songsCountSQL != 0 && isAlert) {
      sub = (SongCount.songsCountFB - SongCount.songsCountSQL).abs();
    }

    // log(SongCount.songsCountFB.toString());
    // log('sql');
    // log(SongCount.songsCountSQL.toString());

    // if (SongCount.songsCountSQL != 0 && isAlert) {
    //   final sub = (SongCount.songsCountFB - SongCount.songsCountSQL).abs();
    //   if (SongCount.songsCountFB > SongCount.songsCountSQL) {
    //     // showDialog(
    //     //     context: context,
    //     //     builder: (context) {
    //     //       return AlertDialog(
    //     //         title: const Text('UPdate 확인'),
    //     //         content: Text('서버의 데이터가 로컬 데이타 보다 $sub 만큼 많습니다.'),
    //     //         actions: [
    //     //           ElevatedButton(
    //     //               onPressed: () {
    //     //                 Navigator.of(context).pop();
    //     //               },
    //     //               child: const Text('Cancel')),
    //     //           ElevatedButton(
    //     //               onPressed: () {
    //     //                 Navigator.of(context).pop();
    //     //               },
    //     //               child: const Text('update')),
    //     //         ],
    //     //       );
    //     //     });
    //     showBottomSheet(
    //         context: context,
    //         builder: (context) {
    //           return Container();
    //         });
    //     print('fb  $sub big');
    //   } else if (SongCount.songsCountFB < SongCount.songsCountSQL) {
    //     print('sql $sub big');
    //   } else {
    //     print('==');
    //   }
    //   isAlert = false;
    // }

    categoryList = ref.watch(songCategoryListNotifierFirebaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Like Songs [FB]'),
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
                context.go('/home_fb/favoriteSongFb');
              } else if (value == 'DB 관리') {
                context.go('/home/testDataManage');
              } else {
                context.go('/home_fb/searchSongFb');
              }
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.4),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.red),
        ),
      ),
      drawer: _drawer(context, ref),
      body: SafeArea(
        child: (SongCount.songsCountSQL != 0 && isAlert)
            ? AlertDialog(
                title: const Text('UPdate 확인'),
                content: Text('서버의 데이터가 로컬 데이타 보다 $sub 만큼 많습니다.'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        isAlert = false;
                        setState(() {});
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        isAlert = false;
                        setState(() {});
                      },
                      child: const Text('update')),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // FilledButton(
                      //     onPressed: () {
                      //       final data = ref.read(songListFirebaseProvider);
                      //       final result = data
                      //           .where((element) =>
                      //               element?.songName.contains('w') ?? false)
                      //           .toList();
                      //       for (var element in result) {
                      //         print(element?.songName);
                      //       }
                      //     },
                      //     child: const Text('test')),
                      IconButton(
                        onPressed: () {
                          // Toggle the sort order between ascending and descending
                          // final sortOrder = ref.read(sortOrderProvider);
                          if (isReversed) {
                            ref.read(sortOrderProvider.notifier).state =
                                SortOrder.ascending;
                          } else {
                            ref.read(sortOrderProvider.notifier).state =
                                SortOrder.descending;
                          }
                          isReversed = !isReversed;
                        },
                        icon: const Icon(Icons.flip_camera_android),
                        iconSize: 30,
                        tooltip: '순서바꾸기',
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '총 곡수: $count 곡, 장르 : $janre',
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 2,
                  //     child: Center(
                  //       child: Container(
                  //         decoration: const BoxDecoration(
                  //           color: Color.fromARGB(255, 168, 74, 67),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: state.isEmpty
                        ? const Center(
                            child: Text('현재 등록 된 곡이 없습니다.\n관리할 곡을 추가하세요.'),
                          )
                        : ListView.separated(
                            itemCount: state.length,
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: SongItemComponentFirebase(
                                    index: index, item: state[index]),
                              );
                            },
                          ),
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SongAddScreenFirebase()));
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
                  builder: (context) => const SongJanreCategoryFirebaseScreen(),
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
          ElevatedButton(
              onPressed: () async {
                // final datas = ref.read(songListFirebaseProvider);
                // for (SongItemModel? item in datas) {
                //   final song = item?.toMap();
                //   if (song != null) {
                //     await FirebaseFirestore.instance
                //         .collection('songs')
                //         .doc(item!.id)
                //         .set(song);
                //   }
                // }
              },
              child: const Text('fb make Data'))
        ],
      ),
    );
  }

  ListTile categoryMenu(
      {required BuildContext context, required String janreName}) {
    return ListTile(
      title: Text(
        janreName,
        style: optionStyle1,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        ref.read(filterFirebaseProvider.notifier).update((state) => janreName);
        final songs = ref.read(filteredSongListFirebaseProvider);
        ref.read(songCountFirebaseProvider.notifier).update(
              (state) => songs.length,
            );
        janre = janreName;
      },
    );
  }
}
