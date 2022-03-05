import 'package:sqflite/sqflite.dart';

import '../models/served.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const _tableName = 'served';

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'served.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name STRING, age INTEGER, '
              'address STRING, phone STRING, '
              'law TEXT, recognitionDate STRING, '
              'intakeDate STRING)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Served? served) async {
    return await _db!.insert(_tableName, served!.toJson());
  }

  static Future<int> delete(Served? served) async {
    return await _db!
        .delete(_tableName, where: 'id=?', whereArgs: [served!.id]);
  }

  static Future<int> deleteAll() async {
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<int> update(
    int id,
    String name,
    String age,
    String phone,
    String address,
    String law,
    String intakeDate,
    String recognitionDate,
  ) async {
    return await _db!.rawUpdate(
      '''
    UPDATE served
    SET name = ?, age = ?, address = ?, phone = ?, law = ?, recognitionDate = ?, intakeDate = ?
    WHERE id = ? 
    ''',
      [name, age, address, phone, law, recognitionDate, intakeDate, id],
    );
  }
}
