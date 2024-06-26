import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/uid_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';

class SongJanreCategoryFirebaseScreen extends ConsumerWidget {
  const SongJanreCategoryFirebaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songCategoryListNotifierFirebaseProvider);
    TextEditingController controller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category 관리'),
        ),
        body: state.isEmpty
            ? Center(
                child: Column(
                  children: [
                    const Text('기록된 노래 관리 장르가 없습니다.'),
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
                              print('pressed');
                              final uid = ref.read(uidProvider);
                              print('uid $uid');
                              int idNum;
                              print(controller.text);
                              String? maxID = await getMaxID(uid);
                              print(maxID);
                              if (maxID == null) {
                                idNum = 1;
                              } else {
                                idNum = int.parse(maxID) + 1;
                              }
                              print('Max ID: $maxID');
                              try {
                                final sic = SongItemCategory(
                                    idNum.toString(), controller.text);
                                final uid = ref.read(uidProvider);
                                print('uid : $uid');
                                await MyFirebaseService.instance
                                    .doc(uid)
                                    .collection('songCategoris')
                                    .doc(idNum.toString())
                                    .set(sic.toMap());

                                await ref
                                    .read(
                                        songCategoryListNotifierFirebaseProvider
                                            .notifier)
                                    .getDBDataFirebaseRefresh();
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
                              // state.remove(tg);
                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${tg.songJanreCategory} Erase'),
                                  ),
                                );
                                final uid = ref.read(uidProvider);
                                await MyFirebaseService.instance
                                    .doc(uid)
                                    .collection('songCategoris')
                                    .doc(state[index].id)
                                    .delete();
                                // await ref
                                //     .read(
                                //         songCategoryListNotifierFirebaseProvider
                                //             .notifier)
                                //     .getDBFirebaseData();
                                await ref
                                    .read(
                                        songCategoryListNotifierFirebaseProvider
                                            .notifier)
                                    .getDBDataFirebaseRefresh();
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
                            final uid = ref.read(uidProvider);
                            String? maxID = await getMaxID(uid);
                            if (maxID != null) {
                              print('Max ID: $maxID');
                              try {
                                final result = maxID;
                                final idNum = int.parse(result) + 1;
                                print('idnum');
                                print(idNum);

                                final sic = SongItemCategory(
                                    idNum.toString(), controller.text);
                                final uid = ref.read(uidProvider);
                                print('saver uid :$uid');
                                await MyFirebaseService.instance
                                    .doc(uid)
                                    .collection('songCategoris')
                                    .doc(idNum.toString())
                                    .set(sic.toMap());
                                print('resp :');
                                await ref
                                    .read(
                                        songCategoryListNotifierFirebaseProvider
                                            .notifier)
                                    // .getDBFirebaseData();
                                    .getDBDataFirebaseRefresh();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'message : success Add category')));
                                controller.text = '';
                              } catch (e) {
                                print('error : $e');
                              }
                            } else {
                              print('No documents found.');
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
                  )
                ],
              ),
      ),
    );
  }

  Future<String?> getMaxID(String uid) async {
    try {
      // Query the collection and order documents by ID in descending order
      QuerySnapshot querySnapshot = await MyFirebaseService.instance
          .doc(uid)
          .collection('songCategoris')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      // Check if any documents were found
      if (querySnapshot.size > 0) {
        // Get the document data and return the value of the 'id' field
        return querySnapshot.docs.first['id'];
      } else {
        // No documents found
        return null;
      }
    } catch (error) {
      print('Error getting max ID: $error');
      print('my error ${error.toString()}');
      return null;
    }
  }
}
