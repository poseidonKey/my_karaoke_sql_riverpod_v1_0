import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

class SongItemComponent extends StatelessWidget {
  final SongItemModel item;
  const SongItemComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(item.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Erase
        }
      },
      child: ListTile(
        title: GestureDetector(
          child: Column(
            children: [
              Text('${item.songName} : [${item.songJanre}]'),
              const Text('금영 - 12345, 태진 - 5678'),
            ],
          ),
          onTap: () {},
        ),
        leading: CircleAvatar(
          radius: 15,
          foregroundColor: Colors.deepPurpleAccent,
          child: Text(
            item.id.toString(),
          ),
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
