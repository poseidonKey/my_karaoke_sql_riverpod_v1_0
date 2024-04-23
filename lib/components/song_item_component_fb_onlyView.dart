import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_view_screen.dart';

class SongItemComponentFirebaseOnlyView extends ConsumerStatefulWidget {
  final SongItemModel item;
  final int index;

  const SongItemComponentFirebaseOnlyView(
      {super.key, required this.index, required this.item});

  @override
  ConsumerState<SongItemComponentFirebaseOnlyView> createState() =>
      _SongItemComponent1State();
}

class _SongItemComponent1State
    extends ConsumerState<SongItemComponentFirebaseOnlyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
