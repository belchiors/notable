import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbContext {
  final _schema = '''CREATE TABLE notes(
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,
    created TEXT,
    edited TEXT,
    isArchived INTEGER DEFAULT 0,
    isDeleted INTEGER DEFAULT 0
  );''';

  Future<String> get dbPath async => join(await getDatabasesPath(), 'notable.db');

  static Database? _database;
  Future<Database?> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    return await openDatabase(await dbPath, version: 1, onCreate: _onCreateDatabase);
  }

  Future<void> _onCreateDatabase(Database db, int version) async {
    await db.execute(_schema);
  }

  DbContext._();
  static final DbContext instance = DbContext._();
}
