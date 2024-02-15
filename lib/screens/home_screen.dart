import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/song_item_component.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/filtered_song_list_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/test_data_manage.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(songItemListNotifierProviderDB);
    final state = ref.watch(songItemListNotifierProviderDB);
    final count = ref.watch(songCountProvider);
    final janreState = ref.watch(filterProvider);
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
      drawer: _drawer(context, ref),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '총 곡수 : $count 곡',
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
                    '곡 추가>>',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w100),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SongItemComponent(item: data[index]),
                      );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TestDataManage(),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _drawer(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songItemListNotifierProviderDB);
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
              ref.read(filterProvider.notifier).state = Janre.BALLADE;
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
              final state = ref
                  .read(songItemListNotifierProvider.notifier)
                  .filterSongItem(
                    janre: '트로트',
                  );
              print(state);

              // print(state);
              // final tmp = state.value!
              //     .where((element) => element.songJanre == '트로트')
              //     .toList();
              // for (var aa in state) {
              //   print(aa.songJanre);
              // }

              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => Container()),
              // );
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
}
