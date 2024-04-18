import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/songs_count_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_edit_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_view_screen.dart';

class SongItemComponent extends ConsumerStatefulWidget {
  final SongItemModel item;
  const SongItemComponent({super.key, required this.item});

  @override
  ConsumerState<SongItemComponent> createState() => _SongItemComponent1State();
}

class _SongItemComponent1State extends ConsumerState<SongItemComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(songItemListNotifierProvider);
    final tg = state.firstWhere((element) => element.id == widget.item.id);
    return Dismissible(
      key: ObjectKey(widget.item.id),
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          state.remove(tg);
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${tg.songName} Erase'),
              ),
            );
            DbHelper helper = DbHelper();
            await helper.openDb();
            await helper.deleteList(widget.item);
            await ref
                .read(songItemListNotifierProvider.notifier)
                .refreshSongsList();
            ref
                .read(songCountProvider.notifier)
                .update((State) => state.length);
            // setState(() async {});
          } catch (e) {
            print(e);
          }
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
                  builder: (context) => SongEditScreen(
                        songItem: widget.item,
                      )),
            );
          },
        ),
        trailing: IconButton(
          icon: (tg.songFavorite == 'true')
              ? const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                ),
          onPressed: () async {
            ref
                .read(songItemListNotifierProvider.notifier)
                .favChangeSongItem(id: widget.item.id!);
            setState(() {});
          },
        ),
      ),
    );
  }
}
