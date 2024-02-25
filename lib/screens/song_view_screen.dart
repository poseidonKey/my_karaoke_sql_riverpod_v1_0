import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/defaut_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/youtube_view_screen.dart';

class SongViewscreen extends StatelessWidget {
  final SongItemModel item;
  const SongViewscreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '곡 상세정보',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            _getContentsValue(subject: '제목 : ', content: item.songName),
            _getContentsValue(
                subject: '장르 : ',
                content: item.songJanre == 'true' ? 'Check' : '추가하지 않음'),
            _getContentsValue(subject: '즐겨찾기 : ', content: item.songFavorite),
            _getContentsValue(subject: '금영노래방 : ', content: item.songGYNumber),
            _getContentsValue(subject: '태진노래방 : ', content: item.songTJNumber),
            _getContentsValue(
                subject: '기록 날짜 : ', content: item.songCreateTime),
            _getContentsValue(subject: '특기사항 : ', content: item.songETC),
            SizedBox(
                child: Container(
              height: 5,
              color: Colors.blueAccent,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '유튜브 보기 :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const YoutubeViewScreen(
                            songUrl:
                                'https://www.youtube.com/watch?v=S6y2S3tfMRQ',
                          );
                          // return const CustomYoutubePlayer();
                        }),
                      );
                    },
                    icon: const Icon(
                      Icons.movie,
                      size: 40,
                    ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('back')),
            )
          ],
        ),
      ),
    );
  }

  Widget _getContentsValue({required String subject, required String content}) {
    const subjectStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    const contentStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(
            subject,
            style: subjectStyle,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(content, style: contentStyle),
        ],
      ),
    );
  }
}
