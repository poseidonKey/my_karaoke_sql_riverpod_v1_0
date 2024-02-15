import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

class TestDataManage extends StatelessWidget {
  const TestDataManage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => makeTestData(count: 5),
                  child: const Text('5개 만들기')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => makeTestData(count: 100),
                  child: const Text('100개 만들기')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: deleteTestData, child: const Text('모든 데이터 지우기')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: deleteTestDatabase, child: const Text('테이블 지우기')),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> getShowData(WidgetRef ref) async {
  //   DbHelper helper = DbHelper();
  //   List<SongItemModel> songList;

  //   await helper.openDb();
  //   songList = await helper.getLists();
  //   if (songList.isEmpty) {
  //     songList = [];
  //   } else {
  //     songList = songList;
  //   }
  // }

  void makeTestData({required int count}) async {
    int cnt = 1;

    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      String songJanre = "";

      for (int i = 0; i < count; i++) {
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
