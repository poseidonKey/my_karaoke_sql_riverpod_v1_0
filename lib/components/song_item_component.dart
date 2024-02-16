import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_provider.dart';

class SongItemComponent extends ConsumerWidget {
  final SongItemModel item;
  const SongItemComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songItemListNotifierProvider);
    return Dismissible(
      key: ObjectKey(item.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Erase
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          foregroundColor: Colors.deepPurpleAccent,
          child: Text(
            item.id.toString(),
          ),
        ),
        title: GestureDetector(
          child: Column(
            children: [
              Text('${item.songName} : [${item.songJanre}]'),
              const Text('금영 - 12345, 태진 - 5678'),
            ],
          ),
          onTap: () {},
        ),
        trailing: IconButton(
          icon: (item.songFavorite == 'true')
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
                .favChangeSongItem(id: item.id!);
            print(item.songFavorite);
            // final t = state.firstWhere((element) => (element.id == item.id));
            // widget.item.songFavorite = (widget.item.songFavorite == 'true')
            //     ? widget.item.songFavorite = 'false'
            //     : widget.item.songFavorite = 'true';
            // setState(() {
            //   fav == 'true' ? fav = 'false' : fav = 'true';
            // });

            // mySongCnprovider.favChange(index);
            // DbHelper helper = DbHelper();
            // await helper.openDb();
            // await helper.changeFavority(
            //     mySongCnprovider.myItems[index],
            //     mySongCnprovider.myItems[index].songFavorite);
            // var app =
            //     Provider.of<MySongChangeNotifierProviderModel>(
            //         context,
            //         listen: false);
            // app.getAllSongs();
          },
        ),
      ),
    );
  }
}
