import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';

class TestDataManage extends StatelessWidget {
  const TestDataManage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Management'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => makeMyData(), child: const Text('내 데이터 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => makeMyDataCategory(),
                child: const Text('내 Category 데이터 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => makeTestData(count: 5),
                child: const Text('5개 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => makeTestData(count: 30),
                child: const Text('30개 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => makeTestData(count: 100),
                child: const Text('100개 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => makeTestData(count: 1000),
                child: const Text('1000개 만들기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: deleteTestData, child: const Text('모든 데이터 지우기')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: deleteTestDatabase, child: const Text('테이블 지우기')),
          ],
        ),
      ),
    );
  }

  // Future<void> getShowData(WidgetRef ref) async {
  //   DbHelper helper = DbHelper();
  //   List<SongItemModel> songList;

  //   await helper.openDb();
  //   songList = await helper.getLists();
  //   if (songList.isEmpty) {
  //     songList = [];
  //   } else {
  //     songList = songList;
  //   }
  // }

  void makeTestData({required int count}) async {
    int cnt = 1;

    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      String songJanre = "";

      for (int i = 0; i < count; i++) {
        if (i % 3 == 0) songJanre = "가요";
        if (i % 3 == 1) songJanre = "팝";
        if (i % 3 == 2) songJanre = "트로트";
        final song = SongItemModel(
            null,
            "song Name ${cnt++}",
            "songGYNumber",
            "songTJNumber",
            songJanre,
            "songUtubeAddress",
            "songETC",
            "2022.1.1",
            "false");

        await helper.insertList(song);
        // print('success');
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteTestDatabase() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      await helper.db!.rawQuery("drop database if exists mysongs");
    } catch (e) {
      print(e);
    }
  }

  void deleteTestTable() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      await helper.db!.rawQuery("drop table if exists mysongs");
    } catch (e) {
      print(e);
    }
  }

  void deleteTestData() async {
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      var result = await helper.deleteAllList();
      if (result == 'success') print("Success");
    } catch (e) {
      print(e);
    }
  }

  void makeMyDataCategory() async {
    List<Map<String, String>> list = [
      {'songJanreCategory': '발라드'},
      {'songJanreCategory': '트로트'},
      {'songJanreCategory': '팝'},
      {'songJanreCategory': '댄스'},
      {'songJanreCategory': '클래식'},
    ];
    print(list);
    try {
      DbHelperCategory helper = DbHelperCategory();
      await helper.openDbCategory();
      for (var i = 0; i < list.length; i++) {
        final song = SongItemCategory(null, list[i]['songJanreCategory']!);

        await helper.insertList(song);
      }
    } catch (e) {
      print(e);
    }
  }

  void makeMyData() async {
    List<Map<String, String>> list = [
      {'songName': '월량대표아적심', 'songJanre': '발라드', 'songGyNumber': '78877'},
      {'songName': '이등병의 편지', 'songJanre': '발라드', 'songGyNumber': '3425'},
      {'songName': '비와 당신', 'songJanre': '발라드', 'songGyNumber': '46485'},
      {'songName': '광화문연가', 'songJanre': '발라드', 'songGyNumber': '3557'},
      {'songName': '붉은 노을', 'songJanre': '댄스', 'songGyNumber': '77082'},
      {'songName': '난 아직 모르잖아요', 'songJanre': '발라드', 'songGyNumber': '828'},
      {'songName': '강원도 아리랑', 'songJanre': '댄스', 'songGyNumber': '114'},
      {'songName': '꿈에', 'songJanre': '발라드', 'songGyNumber': '2278'},
      {'songName': '그것만이 내 세상', 'songJanre': '발라드', 'songGyNumber': '1329'},
      {'songName': '사노라면', 'songJanre': '발라드', 'songGyNumber': '2411'},
      {'songName': '너', 'songJanre': '댄스', 'songGyNumber': '235'},
      {'songName': '슬픈 인연', 'songJanre': '발라드', 'songGyNumber': '4466'},
      {'songName': '옥경이', 'songJanre': '트로트', 'songGyNumber': '80125'},
      {'songName': '사랑은 아무나 하나', 'songJanre': '발라드', 'songGyNumber': '6314'},
      {'songName': '지중해', 'songJanre': '댄스', 'songGyNumber': '5621'},
      {
        'songName': 'Bridge over troubled water',
        'songJanre': '팝',
        'songGyNumber': '1058'
      },
      {'songName': 'My way', 'songJanre': '팝', 'songGyNumber': '1080'},
      {
        'songName': 'Don\'t forget to remember',
        'songJanre': '팝',
        'songGyNumber': '2507'
      },
      {'songName': '마지막 나의 모습', 'songJanre': '발라드', 'songGyNumber': '324'},
      {'songName': '바람과 구름', 'songJanre': '발라드', 'songGyNumber': '9811'},
      {'songName': '구름과 나', 'songJanre': '발라드', 'songGyNumber': '4225'},
      {'songName': '하루', 'songJanre': '발라드', 'songGyNumber': '6713'},
      {'songName': '장미빛 스카프', 'songJanre': '트로트', 'songGyNumber': '673'},
      {'songName': '내 마음 당신 곁으로', 'songJanre': '댄스', 'songGyNumber': '230'},
      {
        'songName': '눈물 한 방울로 사랑은 시작되고',
        'songJanre': '발라드',
        'songGyNumber': '3503'
      },
      {'songName': '울고 싶어라', 'songJanre': '발라드', 'songGyNumber': '614'},
      {'songName': '열애', 'songJanre': '발라드', 'songGyNumber': '586'},
      {'songName': '이름 없는 새', 'songJanre': '발라드', 'songGyNumber': '1712'},
      {'songName': '그대 그리고 나', 'songJanre': '발라드', 'songGyNumber': '999'},
      {'songName': '젊은 미소', 'songJanre': '댄스', 'songGyNumber': '971'},
      {
        'songName': '나는 당신께 사랑을 원하지 않았어요',
        'songJanre': '발라드',
        'songGyNumber': '1651'
      },
      {'songName': '친구', 'songJanre': '발라드', 'songGyNumber': '9321'},
      {'songName': '사랑했어요', 'songJanre': '발라드', 'songGyNumber': '1195'},
      {'songName': '이름모를 소녀', 'songJanre': '발라드', 'songGyNumber': '630'},
      {'songName': '빗속을 둘이서', 'songJanre': '발라드', 'songGyNumber': '435'},
      {'songName': '희나리', 'songJanre': '발라드', 'songGyNumber': '796'},
      {'songName': '초혼', 'songJanre': '트로트', 'songGyNumber': '76588'},
      {'songName': '휘파람을 부세요', 'songJanre': '발라드', 'songGyNumber': '791'},
      {'songName': '석별', 'songJanre': '발라드', 'songGyNumber': '493'},
      {'songName': '슬픈 계절에 만나요', 'songJanre': '발라드', 'songGyNumber': '508'},
      {'songName': '잊혀진 계절', 'songJanre': '발라드', 'songGyNumber': '659'},
      {'songName': '님은 먼 곳에', 'songJanre': '발라드', 'songGyNumber': '261'},
      {'songName': '해후', 'songJanre': '발라드', 'songGyNumber': '771'},
      {'songName': 'TV를 보면서', 'songJanre': '발라드', 'songGyNumber': '3389'},
      {'songName': '티어스', 'songJanre': '댄스', 'songGyNumber': '87402'},
      {'songName': '타타타', 'songJanre': '발라드', 'songGyNumber': '1102'},
      {'songName': 'I have a dream', 'songJanre': '팝', 'songGyNumber': '8865'},
      {
        'songName': 'can\'t help falling in love with you',
        'songJanre': '팝',
        'songGyNumber': '2503'
      },
      {
        'songName': 'Anything that\ts part of you',
        'songJanre': '팝',
        'songGyNumber': '8817'
      },
      {'songName': '작은 새', 'songJanre': '발라드', 'songGyNumber': '661'},
      {'songName': '낭만에 대하여', 'songJanre': '발라드', 'songGyNumber': '3792'},
      {'songName': '내 마음 갈 곳을 잃어', 'songJanre': '발라드', 'songGyNumber': '229'},
      {'songName': '난 참 바보처럼 살았군요', 'songJanre': '발라드', 'songGyNumber': '392'},
      {
        'songName': 'Hotel Callifonia',
        'songJanre': '팝',
        'songGyNumber': '2559'
      },
      {'songName': '대찬 인생', 'songJanre': '댄스', 'songGyNumber': '5117'},
      {'songName': '가시리', 'songJanre': '발라드', 'songGyNumber': '2276'},
      {'songName': '배반의 장미', 'songJanre': '댄스', 'songGyNumber': '4920'},
      {'songName': '안녕', 'songJanre': '발라드', 'songGyNumber': '545'},
      {'songName': '나 그대에게 모드 드리리', 'songJanre': '발라드', 'songGyNumber': '197'},
      {'songName': '슬픔의 심로', 'songJanre': '발라드', 'songGyNumber': '1375'},
      {'songName': '사내', 'songJanre': '트로트', 'songGyNumber': '69597'},
      {'songName': '하늘이여', 'songJanre': '댄스', 'songGyNumber': '987'},
      {'songName': '너를 사랑하고도', 'songJanre': '발라드', 'songGyNumber': '236'},
      {'songName': '묻어버린 아픔', 'songJanre': '발라드', 'songGyNumber': '1340'},
      {'songName': '거짓말', 'songJanre': '댄스', 'songGyNumber': '828'},
      {'songName': '불인별곡', 'songJanre': '발라드', 'songGyNumber': '828'},
      {'songName': '나 가거든', 'songJanre': '발라드', 'songGyNumber': '828'},
      {'songName': '당신은 몰라', 'songJanre': '발라드', 'songGyNumber': '828'},
      {'songName': '비원', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': 'IOU', 'songJanre': '팝', 'songGyNumber': '4802'},
      {'songName': 'what\'s up', 'songJanre': '팝', 'songGyNumber': '2459'},
      {'songName': 'when I dream', 'songJanre': '팝', 'songGyNumber': '5818'},
      {
        'songName': 'unchained melody',
        'songJanre': '팝',
        'songGyNumber': '3062'
      },
      {
        'songName': 'My heart will go on',
        'songJanre': '팝',
        'songGyNumber': '5492'
      },
      {
        'songName': 'the power of love',
        'songJanre': '팝',
        'songGyNumber': '61642'
      },
      {'songName': 'nella fantasia', 'songJanre': '팝', 'songGyNumber': '84993'},
      {
        'songName': 'the house of rising sun',
        'songJanre': '팝',
        'songGyNumber': '1089'
      },
      {
        'songName': 'green green grass of home',
        'songJanre': '팝',
        'songGyNumber': '139'
      },
      {'songName': '가을 사랑', 'songJanre': '발라드', 'songGyNumber': '2130'},
      {'songName': '고별-홍민', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': '하늘색 꿈', 'songJanre': '발라드', 'songGyNumber': '98146'},
      {'songName': '썸머 와인', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': 'Sailing', 'songJanre': '팝', 'songGyNumber': '2910'},
      {'songName': '카사블랑카', 'songJanre': '발라드', 'songGyNumber': '7478'},
      {'songName': '가을 비 우산속에', 'songJanre': '발라드', 'songGyNumber': '105'},
      {'songName': '당신은 몰라', 'songJanre': '발라드', 'songGyNumber': '274'},
      {'songName': '별리', 'songJanre': '발라드', 'songGyNumber': '2253'},
      {'songName': '가을을 남기고 간 사랑', 'songJanre': '발라드', 'songGyNumber': ''},
      {
        'songName': 'You mean everything to me',
        'songJanre': '팝',
        'songGyNumber': ''
      },
      {'songName': '내일', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': '왜 모르시나', 'songJanre': '발라드', 'songGyNumber': '28'},
      {'songName': '모두 다 사랑하리', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': '못 다핀 꽃 한송이', 'songJanre': '발라드', 'songGyNumber': ''},
      {'songName': 'Sad movie', 'songJanre': '팝', 'songGyNumber': '93154'},
      {'songName': '촛불 잔치', 'songJanre': '발라드', 'songGyNumber': '720'},
      {'songName': '그집 앞', 'songJanre': '발라드', 'songGyNumber': '68045'},
      {'songName': '내일로 가는 마차', 'songJanre': '발라드', 'songGyNumber': '4291'},
      {'songName': '눈이 내리네-김추자', 'songJanre': '발라드', 'songGyNumber': '4650'},
    ];
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      for (var i = 0; i < list.length; i++) {
        // print(list[i]['songName']);
        // print(list[i]['songGyNumber']);
        // print(list[i]['songJanre']);
        final song = SongItemModel(
            null,
            list[i]['songName']!,
            list[i]['songGyNumber']!,
            "songTJNumber",
            list[i]['songJanre']!,
            "songUtubeAddress",
            "songETC",
            "2022.1.1",
            "false");

        await helper.insertList(song);
      }
    } catch (e) {
      print(e);
    }
  }
}
