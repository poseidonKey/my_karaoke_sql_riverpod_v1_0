import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/song_count.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/filtered_song_list_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/uid_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/random_home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_data_update.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_janre_category_fb_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenFirebase extends ConsumerStatefulWidget {
  const HomeScreenFirebase({super.key});

  @override
  ConsumerState<HomeScreenFirebase> createState() => _HomeScreenFirebaseState();
}

class _HomeScreenFirebaseState extends ConsumerState<HomeScreenFirebase> {
  final ScrollController controller = ScrollController();
  final List<String> popupMenu = ['즐겨찾기 화면', '곡 찾기 화면', 'DB 관리'];
  late List<SongItemCategory> categoryList;
  int sub = 0;

  String janre = '모든 곡';
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
    categoryList = ref.read(songCategoryListNotifierFirebaseProvider);
    // print('categori list:${categoryList.length}');
    addUID();
  }

  void addUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('UID');
    if (uid != null) {
      ref.read(uidProvider.notifier).state = uid;
    } else {
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // songAlert();
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
    if (SongCount.songsCountSQL != 0 && MyFirebaseService.isAlert) {
      sub = (SongCount.songsCountFB - SongCount.songsCountSQL).abs();
    }

    categoryList = ref.watch(songCategoryListNotifierFirebaseProvider);
    print('cate list : ${categoryList.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '애창곡 [외부데이터]',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
        child: (SongCount.songsCountSQL != 0 &&
                MyFirebaseService.isAlert &&
                sub != 0)
            ? AlertDialog(
                title: const Text('Update 확인, 개발 진행 중!'),
                content: Text('서버의 데이터와 로컬 데이타가 $sub 차이가 있습니다.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      MyFirebaseService.isAlert = false;
                      setState(() {});
                    },
                    child: const Text('그냥 진행'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      MyFirebaseService.isAlert = false;
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return SongDataUpdate(
                            sqlData: SongCount.songsCountSQL,
                            fbData: SongCount.songsCountFB,
                          );
                        }),
                      );
                    },
                    child: const Text('동기화 하기'),
                  ),
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
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SongAddScreenFirebase(),
            ),
          );
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
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 8,
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
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('userId');
                await prefs.remove('password');
                await prefs.remove('UID');
                ref.read(uidProvider.notifier).state = '';
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                context.go('/auth');
                Navigator.of(context).pop();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () async {
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
          // },
          // child: const Text('fb make Data'))
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
