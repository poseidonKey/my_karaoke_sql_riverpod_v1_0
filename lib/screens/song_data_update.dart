import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDataUpdate extends ConsumerStatefulWidget {
  final int sqlData;
  final int fbData;
  const SongDataUpdate({
    required this.fbData,
    required this.sqlData,
    super.key,
  });

  @override
  ConsumerState<SongDataUpdate> createState() => _SongDataUpdateState();
}

class _SongDataUpdateState extends ConsumerState<SongDataUpdate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('동기화 하기'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '내부 데이터 : ${widget.sqlData.toString()}, 원격 데이터: ${widget.fbData.toString()}'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final result = await dataSync(context, true, ref);
                          if (result == 'ok') {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('확인!'),
                                    content: const Text(
                                        '동기화 처리 했습니다.\n메인 화면으로 넘어갑니다.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ref
                                                .read(songListFirebaseProvider
                                                    .notifier)
                                                .refreshSongDataAndSortByNo();
                                            context.go('/home_fb');
                                          },
                                          child: const Text('Close'))
                                    ]);
                              },
                            );
                          } else {
                            print('error');
                          }
                        },
                        child: const Text('적은 쪽에 추가하기')),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final result = await dataSync(context, false, ref);
                          if (result == 'ok') {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('확인!'),
                                    content: const Text(
                                        '동기화 처리 했습니다.\n메인 화면으로 넘어갑니다.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ref
                                                .read(songListFirebaseProvider
                                                    .notifier)
                                                .refreshSongDataAndSortByNo();
                                            context.go('/home_fb');
                                          },
                                          child: const Text('Close'))
                                    ]);
                              },
                            );
                          } else {
                            print('error');
                          }
                        },
                        child: const Text('많은 쪽 데이터 삭제하기')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/home_fb');
                  },
                  child: const Text('Cancel'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> dataSync(BuildContext context, bool isAdd, WidgetRef ref) async {
  DbHelper helper = DbHelper();
  await helper.openDb();
  final sqlData = await helper.getDataAllLists();
  print(sqlData.length);
  final fbData = ref.read(songListFirebaseProvider);
  print(fbData.length);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('UID');

  /// 적은 쪽 데이터 추가
  if (isAdd) {
    if (fbData.length > sqlData.length) {
      for (var song in fbData) {
        final result = sqlData.where((test) => test.id == song!.id);
        if (result.isEmpty) {
          await helper.insertList(song!);
        }
      }
      return 'ok';
    } else {
      fbData.forEach((song) async {
        await MyFirebaseService.instance
            .doc(uid)
            .collection('songs')
            .doc(song!.id)
            .delete();
      });
      sqlData.forEach((song) async {
        await MyFirebaseService.instance
            .doc(uid)
            .collection('songs')
            .doc(song.id)
            .set(song.toMap());
      });
      return 'ok';
    }
  } else {
    /// 많은 쪽 데이터 삭제
    if (fbData.length > sqlData.length) {
      fbData.forEach((song) async {
        await MyFirebaseService.instance
            .doc(uid)
            .collection('songs')
            .doc(song!.id)
            .delete();
      });
      sqlData.forEach((song) async {
        await MyFirebaseService.instance
            .doc(uid)
            .collection('songs')
            .doc(song.id)
            .set(song.toMap());
      });
      return 'ok';
    } else {
      sqlData.forEach((song) async {
        await helper.deleteList(song);
      });
      fbData.forEach((song) async {
        await helper.insertList(song!);
      });
    }
    return 'ok';
  }
}
