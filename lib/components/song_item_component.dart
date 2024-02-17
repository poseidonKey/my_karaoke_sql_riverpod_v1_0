import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

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
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Erase
          state.remove(tg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${tg.songName} Erase'),
            ),
          );
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
            children: [
              Text('${widget.item.songName} : [${widget.item.songJanre}]'),
              const Text('금영 - 12345, 태진 - 5678'),
            ],
          ),
          onTap: () {
            print(widget.item.id);
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
