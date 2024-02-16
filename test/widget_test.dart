import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

void main() {
  int cnt = 1;
  final List<SongItemModel?> tmp = [
    SongItemModel(null, "song Name ${cnt++}", "songGYNumber", "songTJNumber",
        '트로트', "songUtubeAddress", "songETC", "2022.1.1", "false"),
    SongItemModel(null, "song Name ${cnt++}", "songGYNumber", "songTJNumber",
        '가요', "songUtubeAddress", "songETC", "2022.1.1", "false"),
    SongItemModel(null, "song Name ${cnt++}", "songGYNumber", "songTJNumber",
        '클래식', "songUtubeAddress", "songETC", "2022.1.1", "false"),
    SongItemModel(null, "song Name ${cnt++}", "songGYNumber", "songTJNumber",
        '클래식', "songUtubeAddress", "songETC", "2022.1.1", "false"),
    SongItemModel(null, "song Name ${cnt++}", "songGYNumber", "songTJNumber",
        '트로트', "songUtubeAddress", "songETC", "2022.1.1", "false"),
  ];
  print(tmp.map((e) => (e?.songJanre == '트로트') ? e : null).toList());
  final aa = tmp.map((e) => (e?.songJanre == '트로트') ? e : null).toList();
  print(tmp.where((element) => element?.songJanre == '트로트').toList());
  List<SongItemModel> bb = [];
  for (var a in aa) {
    if (a != null) {
      bb.add(a);
    }
  }
  print(bb);
}
