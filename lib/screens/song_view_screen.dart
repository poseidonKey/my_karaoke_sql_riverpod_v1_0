import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/custom_youtube_player.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/defaut_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

class SongViewscreen extends StatelessWidget {
  final SongItemModel item;
  const SongViewscreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '곡 상세정보',
      body: Column(
        children: [
          Text('제목 : ${item.songName}'),
          Text('장르 : ${item.songJanre}'),
          Text('즐겨찾기 : ${item.songFavorite}'),
          Text('금영노래방 : ${item.songGYNumber}'),
          Text('태진노래방 : ${item.songTJNumber}'),
          Text('기록날짜 : ${item.songCreateTime}'),
          Text('특기사항 : ${item.songETC}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('유튜브 보기 '),
              // Text('보기 : ${item.songUtubeAddress}'),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const CustomYoutubePlayer();
                      }),
                    );
                  },
                  icon: const Icon(Icons.view_agenda))
            ],
          ),
        ],
      ),
    );
  }
}
