import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }
  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'mysongs.db'),
        onCreate: (database, version) {
      database.execute(
          'CREATE TABLE mysongs(id INTEGER PRIMARY KEY, songName TEXT, songGYNumber text, songTJNumber text, songJanre text, songUtubeAddress text, songETC text, songCreateTime text, songFavorite text)');
    }, version: version);
    return db!;
  }

  Future<List<SongItemModel>> getDataAllLists() async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'mysongs',
      orderBy: 'id DESC',
    );
    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return SongItemModel(
          maps[i]["id"].toString(),
          maps[i]["songName"],
          maps[i]["songGYNumber"],
          maps[i]["songTJNumber"],
          maps[i]["songJanre"],
          maps[i]["songUtubeAddress"],
          maps[i]["songETC"],
          maps[i]["songCreateTime"],
          maps[i]["songFavorite"]);
    });
  }

  Future<List<SongItemModel>> getDataCountLists({
    required int count,
  }) async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'mysongs',
      limit: count,
      orderBy: 'id DESC',
    );
    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return SongItemModel(
          maps[i]["id"].toString(),
          maps[i]["songName"],
          maps[i]["songGYNumber"],
          maps[i]["songTJNumber"],
          maps[i]["songJanre"],
          maps[i]["songUtubeAddress"],
          maps[i]["songETC"],
          maps[i]["songCreateTime"],
          maps[i]["songFavorite"]);
    });
  }

  Future<int> insertList(SongItemModel list) async {
    int id = await db!.insert(
      'mysongs',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteList(SongItemModel list) async {
    int id = await db!.delete("mysongs", where: "id = ?", whereArgs: [list.id]);
    return id;
  }

  Future<void> changeFavority(SongItemModel list, String val) async {
    await db!.rawUpdate(
        "update mysongs set songFavorite='$val' where id=${list.id}");
  }

  Future<void> updateData(SongItemModel list) async {
    await db!.rawUpdate(
        "update mysongs set songName='${list.songName}', songTJNumber='${list.songTJNumber}', songGYNumber='${list.songGYNumber}', songUtubeAddress='${list.songUtubeAddress}', songETC='${list.songETC}', songJanre='${list.songJanre}', songFavorite='${list.songFavorite}' where id=${list.id}");
  }

  Future<void> changeSongName(SongItemModel list, String val) async {
    await db!
        .rawUpdate("update mysongs set songName='$val' where id=${list.id}");
  }

  Future<String> deleteAllList() async {
    await db!.delete("mysongs");
    return 'delete success';
  }

  Future<List<SongItemModel>> searchList(
      String searchValue, String target) async {
    String query = "select * from mysongs where $target like '%$searchValue%'";
    // String query =
    //     "SELECT * FROM mysongs WHERE $target COLLATE NOCASE LIKE '%$searchValue%'";
    // String query =
    //     "SELECT * FROM mysongs WHERE songName LIKE '%UNIcode('노래')%'";
    // print(query);

    // String query = "select * from mysongs where $target like '%$searchValue%'";
    final List<Map<String, dynamic>> maps = await db!.rawQuery(query);
    print(maps);
    return maps
        .map(
          (e) => SongItemModel(
              e["id"].toString(),
              e["songName"],
              e["songGYNumber"],
              e["songTJNumber"],
              e["songJanre"],
              e["songUtubeAddress"],
              e["songETC"],
              e["songCreateTime"],
              e["songFavorite"]),
        )
        .toList();
  }
}
