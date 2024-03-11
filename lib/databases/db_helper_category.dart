import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperCategory {
  final int version = 1;
  Database? dbCate;

  static final DbHelperCategory _dbHelperCategory =
      DbHelperCategory._internal();
  DbHelperCategory._internal();
  factory DbHelperCategory() {
    return _dbHelperCategory;
  }
  Future<Database> openDbCategory() async {
    dbCate ??=
        await openDatabase(join(await getDatabasesPath(), 'mysongscategory.db'),
            onCreate: (database, version) {
      database.execute(
          'CREATE TABLE mysongscategory(id INTEGER PRIMARY KEY, songJanreCategory text )');
    }, version: version);
    return dbCate!;
  }

  Future<List<SongItemCategory>> getLists() async {
    final List<Map<String, dynamic>> maps =
        await dbCate!.query('mysongscategory');
    print(maps);
    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return SongItemCategory(
          maps[i]["id"].toString(), maps[i]["songJanreCategory"]);
    });
  }

  Future<int> insertList(SongItemCategory list) async {
    int id = await dbCate!.insert(
      'mysongscategory',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteList(SongItemCategory list) async {
    int id = await dbCate!
        .delete("mysongscategory", where: "id = ?", whereArgs: [list.id]);
    return id;
  }

  Future<void> changeSongName(SongItemCategory list, String val) async {
    await dbCate!.rawUpdate(
        "update mysongscategory set songJanreCategory='$val' where id=${list.id}");
  }

  Future<String> deleteAllList() async {
    await dbCate!.delete("mysongscategory");
    return 'delete success';
  }

  Future<List<SongItemCategory>> searchList(
      String searchTerm, String target) async {
    String query =
        "select * from mysongscategory where $target like '%$searchTerm%'";
    final List<Map<String, dynamic>> maps = await dbCate!.rawQuery(query);
    return maps
        .map(
          (e) => SongItemCategory(e["id"].toString(), e["songJanreCategory"]),
        )
        .toList();
  }
}
