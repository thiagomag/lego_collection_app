import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/lego_set.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'lego_sets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE lego_sets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      officialPage TEXT,
      imagePaths TEXT,
      pieces INTEGER,
      price REAL
    )
  ''');
  }


  Future<int> insertLegoSet(Map<String, dynamic> legoSet) async {
    final db = await database;
    return await db.insert('lego_sets', legoSet);
  }

  Future<List<Map<String, dynamic>>> getLegoSets() async {
    final db = await database;
    return await db.query('lego_sets');
  }

  Future<void> deleteLegoSet(int id) async {
    final db = await database;
    await db.delete('lego_sets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateLegoSet(LegoSet legoSet) async {
    final db = await database;
    await db.update(
      'lego_sets',
      legoSet.toMap(),
      where: 'id = ?',
      whereArgs: [legoSet.id],
    );
  }

  Future<LegoSet> getLegoSetById(int? id) async {
    final db = await database;
    return db.query('lego_sets', where: 'id = ?', whereArgs: [id]).then((maps) {
      if (maps.isNotEmpty) {
        return LegoSet.fromMap(maps.first);
      } else {
        throw Exception('ID não encontrado');
      }
    });
  }
}