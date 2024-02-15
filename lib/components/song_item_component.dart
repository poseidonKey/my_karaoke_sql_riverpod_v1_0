import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

class SongItemComponent extends StatelessWidget {
  final SongItemModel item;
  const SongItemComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.songName),
    );
  }
}
