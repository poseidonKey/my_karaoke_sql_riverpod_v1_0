import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperCategory {
  final int version = 1;
  Database? dbCate;
  final String tableName = 'mysongscategory';

  static final DbHelperCategory _dbHelperCategory =
      DbHelperCategory._internal();
  DbHelperCategory._internal();
  factory DbHelperCategory() {
    return _dbHelperCategory;
  }

  Future<bool> tableExists(Database db, String tableName) async {
    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return tables.isNotEmpty;
  }

  Future<Database> openDbCategory() async {
    dbCate ??=
        await openDatabase(join(await getDatabasesPath(), 'mysongscategory.db'),
            onCreate: (database, version) {
      database.execute(
          'CREATE TABLE ${_dbHelperCategory.tableName}(id INTEGER PRIMARY KEY, songJanreCategory text )');
    }, version: version);
    return dbCate!;
  }

  Future<List<SongItemCategory>> getLists() async {
    final List<Map<String, dynamic>> maps =
        await dbCate!.query(_dbHelperCategory.tableName);
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
      _dbHelperCategory.tableName,
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteList(SongItemCategory list) async {
    int id = await dbCate!.delete(_dbHelperCategory.tableName,
        where: "id = ?", whereArgs: [list.id]);
    return id;
  }

  Future<void> changeSongName(SongItemCategory list, String val) async {
    await dbCate!.rawUpdate(
        "update ${_dbHelperCategory.tableName} set songJanreCategory='$val' where id=${list.id}");
  }

  Future<String> deleteAllList() async {
    await dbCate!.delete(_dbHelperCategory.tableName);
    return 'delete success';
  }

  Future<List<SongItemCategory>> searchList(
      String searchTerm, String target) async {
    String query =
        "select * from ${_dbHelperCategory.tableName} where $target like '%$searchTerm%'";
    final List<Map<String, dynamic>> maps = await dbCate!.rawQuery(query);
    return maps
        .map(
          (e) => SongItemCategory(e["id"].toString(), e["songJanreCategory"]),
        )
        .toList();
  }
}
