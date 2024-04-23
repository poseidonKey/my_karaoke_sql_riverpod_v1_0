import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_edit_screen_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_view_screen.dart';

class SongItemComponentFirebase extends ConsumerStatefulWidget {
  final SongItemModel item;
  final int index;

  const SongItemComponentFirebase(
      {super.key, required this.index, required this.item});

  @override
  ConsumerState<SongItemComponentFirebase> createState() =>
      _SongItemComponent1State();
}

class _SongItemComponent1State
    extends ConsumerState<SongItemComponentFirebase> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(songListFirebaseProvider);
    final tg = state.firstWhere((element) => element!.id == widget.item.id);
    return Dismissible(
      key: ObjectKey(widget.item.id),
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                final removedCategory = state[widget.index];
                ref
                    .read(songListFirebaseProvider.notifier)
                    .removeItem(widget.index);
                return AlertDialog(
                  title: const Text('노래 삭제'),
                  content: const Text('데이터가 삭제 됩니다.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('songs')
                            .doc(widget.item.id)
                            .delete();
                        await ref
                            .read(songListFirebaseProvider.notifier)
                            .refreshSongDataAndSortByNo();
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${tg.songName} Erase'),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }

                        Navigator.of(context).pop();
                      },
                      child: const Text('확인'),
                    ),
                    TextButton(
                      onPressed: () async {
                        ref
                            .read(songListFirebaseProvider.notifier)
                            .undoRemoveItem(widget.index, removedCategory!);
                        Navigator.of(context).pop();
                      },
                      child: const Text('취소'),
                    ),
                  ],
                );
              });
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          foregroundColor: Colors.deepPurpleAccent,
          child: Text(
            widget.item.id.toString(),
          ),
        ),
        title: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: '곡명: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16)),
                    TextSpan(
                        text: '${widget.item.songName} -',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                    TextSpan(
                      text: ' [${widget.item.songJanre}]',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '금영 - ${widget.item.songGYNumber}, 태진 - 12345',
                // '금영 - ${widget.item.songGYNumber}, 태진 - ${widget.item.songTJNumber}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          onTap: () {
            // context.go('/home/songView');
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SongViewscreen(
                        item: widget.item,
                      )),
            );
            print(widget.item.id);
          },
          onDoubleTap: () {
            // context.go('/home/songEdit');
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SongEditScreenFirebase(
                        songItem: widget.item,
                      )),
            );
          },
        ),
        trailing: IconButton(
          icon: (tg!.songFavorite == 'true')
              ? const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                ),
          onPressed: () async {
            String str;
            if (tg.songFavorite == 'true') {
              str = 'false';
            } else {
              str = 'true';
            }
            await FirebaseFirestore.instance
                .collection('songs')
                .doc(tg.id)
                .update({'songFavorite': str});
            ref
                .read(songListFirebaseProvider.notifier)
                .favChangeSongItem(id: widget.item.id!);
            setState(() {});
          },
        ),
      ),
    );
  }
}
