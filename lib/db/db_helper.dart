// ignore_for_file: unused_field, prefer_const_declarations, unused_local_variable, empty_catches

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _database;
  static final int _version = 1;
  static final String _tabelName = 'tasks';

  static Future<void> initDb() async {
    if (_database != null) {
      print('DataBase is not null');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        _database = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('db craeted');
          // When creating the db, create the table
          await db.execute('CREATE TABLE $_tabelName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function called');
    return await _database!.insert(_tabelName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    print('delete function called');
    return await _database!
        .delete(_tabelName, where: 'id= ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print('delete function called');
    return await _database!.delete(_tabelName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _database!.query(_tabelName);
  }

  static Future<int> update(int id) async {
    print('update function called');
    return await _database!.rawUpdate('''
        UPDATE $_tabelName 
        SET isCompleted = ?
         WHERE id = ?
         ''', [1, id]);
  }
}
