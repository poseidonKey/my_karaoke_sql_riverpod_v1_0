import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songItemListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Like Songs'),
        actions: [
          const Text(
            '즐찾',
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          const Text(
            '곡찾기',
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return Container();
                }),
              );
            },
            icon: const Icon(Icons.search),
          )
          // IconButton(
          //     onPressed: makeTestData, icon: const Icon(Icons.credit_card)),
          // IconButton(onPressed: deleteTestData, icon: const Icon(Icons.delete)),
        ],
      ),
      drawer: _drawer(context),
      body: Column(
        children: [
          const Text(
            '총 곡수 : oo 개',
            style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const SizedBox(
            width: 20,
          ),
          state.when(
              data: (data) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 5,
                      child: Container(
                        color: Colors.grey.shade300,
                        width: 100,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      return SongItemComponent(item: data[index]);
                    },
                  ),
                );
              },
              error: (error, stack) {
                return Text(error.toString());
              },
              loading: () => const CircularProgressIndicator())
        ],
      ),
    );
  }

  Widget _drawer(BuildContext context) {
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
              '발라드',
              style: optionStyle1,
            ),
            onTap: () async {
              print(Janre.BALLADE);
              DbHelper helper = DbHelper();
              await helper.openDb();
              var result = await helper.searchList("발라드", "songJanre");
              for (var element in result) {
                print(element);
              }
            },
          ),
          ListTile(
            title: const Text(
              '댄스',
              style: optionStyle1,
            ),
            onTap: () async {
              DbHelper helper = DbHelper();
              await helper.openDb();
              var result = await helper.searchList("댄스", "songJanre");
              for (var element in result) {
                print(element);
              }
            },
          ),
          ListTile(
            title: const Text(
              '트로트',
              style: optionStyle1,
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Container()),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          ListTile(
            title: const Text(
              '클래식',
              style: optionStyle1,
            ),
            onTap: () async {
              DbHelper helper = DbHelper();
              await helper.openDb();
              var result = await helper.searchList("클래식", "songJanre");
              for (var element in result) {
                print(element);
              }
            },
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
          )
        ],
      ),
    );
  }

  Future<void> getShowData(WidgetRef ref) async {
    DbHelper helper = DbHelper();
    List<SongItemModel> songList;

    await helper.openDb();
    songList = await helper.getLists();
    if (songList.isEmpty) {
      songList = [];
    } else {
      songList = songList;
    }
  }

  void makeTestData() async {
    int cnt = 1;

    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      String songJanre = "";

      for (int i = 0; i < 30; i++) {
        if (i % 3 == 0) songJanre = "가요";
        if (i % 3 == 1) songJanre = "팝";
        if (i % 3 == 2) songJanre = "트로트";
        final song = SongItemModel(
            null,
            "song Name ${cnt++}",
            "songGYNumber",
            "songTJNumber",
            songJanre,
            "songUtubeAddress",
            "songETC",
            "2022.1.1",
            "false");

        await helper.insertList(song);
        // print('success');
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteTestDatabase() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      await helper.db!.rawQuery("drop database if exists mysongs");
    } catch (e) {
      print(e);
    }
  }

  void deleteTestTable() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      await helper.db!.rawQuery("drop table if exists mysongs");
    } catch (e) {
      print(e);
    }
  }

  void deleteTestData() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      var result = await helper.deleteAllList();
      if (result == 'success') print("Success");
    } catch (e) {
      print(e);
    }
  }
}
