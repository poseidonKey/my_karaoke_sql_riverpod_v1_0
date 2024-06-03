import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_provider.dart';

class SongJanreCategoryScreen extends ConsumerWidget {
  const SongJanreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songCategoryListNotifierProvider);
    TextEditingController controller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category 관리'),
        ),
        body: state.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const Flexible(
                      flex: 2,
                      child: Center(
                        child: Text('empty'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 5,
                        child: Container(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: '추가할 쟝르'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                print(controller.text);
                                try {
                                  DbHelperCategory helper = DbHelperCategory();
                                  await helper.openDbCategory();
                                  final result = await helper.lastID();
                                  int idNum;
                                  if (result.isEmpty) {
                                    idNum = 1;
                                  } else {
                                    idNum = int.parse(result[0].id!) + 1;
                                  }
                                  print(idNum);

                                  final sic = SongItemCategory(
                                      idNum.toString(), controller.text);
                                  await helper.insertList(sic);
                                  await ref
                                      .read(songCategoryListNotifierProvider
                                          .notifier)
                                      .getDBDataRefresh();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'message : success Add category')));
                                  controller.text = '';
                                } catch (e) {
                                  print('error : $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text('Add'),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: ObjectKey(state[index].id),
                          onDismissed: (direction) async {
                            final tg = state.firstWhere(
                                (element) => element.id == state[index].id);
                            if (direction == DismissDirection.startToEnd) {
                              state.remove(tg);
                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${tg.songJanreCategory} Erase'),
                                  ),
                                );
                                DbHelperCategory helper = DbHelperCategory();
                                await helper.openDbCategory();
                                await helper.deleteList(tg);
                                await ref
                                    .read(songCategoryListNotifierProvider
                                        .notifier)
                                    .getDBDataRefresh();
                                // ref
                                //     .read(songCountProvider.notifier)
                                //     .update((State) => state.length);
                                // setState(() async {});
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                '${state[index].id} - ${state[index].songJanreCategory}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              onLongPress: () =>
                                  print(state[index].songJanreCategory),
                            ),
                          ),
                        );
                      },
                      itemCount: state.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 10,
                        child: Container(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 5,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: '추가할 쟝르'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print(controller.text);
                            try {
                              DbHelperCategory helper = DbHelperCategory();
                              await helper.openDbCategory();
                              final result = await helper.lastID();
                              final idNum = int.parse(result[0].id!) + 1;
                              // print(idNum);

                              final sic = SongItemCategory(
                                  idNum.toString(), controller.text);
                              await helper.insertList(sic);
                              await ref
                                  .read(
                                      songCategoryListNotifierProvider.notifier)
                                  .getDBDataRefresh();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'message : success Add category')));
                              controller.text = '';
                            } catch (e) {
                              print('error : $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red),
                          child: const Text('Add SQL'),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
