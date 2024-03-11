import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class SqlTest extends StatefulWidget {
  const SqlTest({super.key});

  @override
  State<SqlTest> createState() => _SqlTestState();
}

class _SqlTestState extends State<SqlTest> {
  String msg = 'meseage';
  Database? dbCate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sql'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('message : $msg'),
          ElevatedButton(
              onPressed: () async {
                dbCate = await openDbCategory();
                setState(() {
                  msg = dbCate.toString();
                });
              },
              child: const Text('make sql')),
          ElevatedButton(
              onPressed: () async {
                var item = SongItemCategory(null, 'ballade');
                final result = await insertList(item);
                setState(() {
                  msg = result.toString();
                });
              },
              child: const Text('insert sql')),
          ElevatedButton(
              onPressed: () async {
                var result = await deleteAllList();
                setState(() {
                  msg = result.toString();
                });
              },
              child: const Text('모든 데이터 지우기')),
          ElevatedButton(
              onPressed: () async {
                var result = await deleteTable();
                setState(() {
                  msg = result.toString();
                });
              },
              child: const Text('table 지우기')),
          ElevatedButton(
              onPressed: () async {
                var result = await deleteTestDatabase();
                setState(() {
                  msg = result.toString();
                });
              },
              child: const Text('database 지우기')),
          ElevatedButton(
              onPressed: () async {
                var result = await tableExistTest();
                setState(() {
                  msg = result.toString();
                });
              },
              child: const Text('table 존재 확인')),
        ],
      ),
    );
  }

  Future<String> deleteTestDatabase() async {
    // final resp =
    //     await dbCate!.query("SELECT * FROM drop database if exists mycate");
    // return resp.toString();
    String databasePath = join(await getDatabasesPath(), 'mycate.db');

    // Check if the database file exists
    bool exists = await File(databasePath).exists();

    if (exists) {
      // Delete the database file
      await File(databasePath).delete();
      return 'Database mycate.db has been deleted.';
    } else {
      return 'Database mycate.db does not exist.';
    }
  }

  Future<String> deleteTable() async {
    await dbCate!.execute("drop table if exists mycate");
    await dbCate!.close();
    return 'success';
  }

  Future<String> deleteAllList() async {
    await dbCate!.delete('mycate');
    return 'delete success';
  }

  Future<int> insertList(SongItemCategory item) async {
    String tableName = 'mycate';
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'mycate.db'),
      version: 1,
    );
    final isExist = await tableExists(database, tableName);
    if (!isExist) {
      await database.execute('''
    CREATE TABLE $tableName(id INTEGER PRIMARY KEY, songJanreCategory text )
  ''');
    }
    int id = await database.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<Database> openDbCategory() async {
    const int version = 1;
    Database? dbCate;
    const String tableName = 'mycate';
    dbCate ??= await openDatabase(join(await getDatabasesPath(), 'mycate.db'),
        onCreate: (database, version) {
      database.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, songJanreCategory text )');
    }, version: version);
    return dbCate;
  }

  Future<bool> tableExists(Database db, String tableName) async {
    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return tables.isNotEmpty;
  }

  Future<String> tableExistTest() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'mycate.db'),
      version: 1,
    );

    String tableName = 'mycate';

    if (await tableExists(database, tableName)) {
      print('Table $tableName exists.');
      return 'exist';
    } else {
      print('Table $tableName does not exist.');
      return 'not exist';
    }

    // await database.close();
  }
}
