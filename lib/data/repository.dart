import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sqflite/sqflite.dart';
import 'package:notable/data/database.dart';
import 'package:notable/model/note_model.dart';

class Repository {
  final DbContext _dbContext = DbContext.instance;

  Future<List<Note>> getAll() async {
    var db = await _dbContext.database;
    var data = await db?.rawQuery('SELECT * FROM notes WHERE (isArchived = 0 AND isDeleted = 0)');
    return List.generate(data!.length, (i) => Note.fromMap(data[i]));
  }

  Future<List<Note>> getAllArchived() async {
    var db = await _dbContext.database;
    var data = await db?.rawQuery('SELECT * FROM notes WHERE (isArchived = 1 AND isDeleted = 0)');
    return List.generate(data!.length, (i) => Note.fromMap(data[i]));
  }

  Future<List<Note>> getAllDeleted() async {
    var db = await _dbContext.database;
    var data = await db?.rawQuery('SELECT * FROM notes WHERE isDeleted = 1');
    return List.generate(data!.length, (i) => Note.fromMap(data[i]));
  }

  Future<void> insert(Note note) async {
    var db = await _dbContext.database;
    await db?.insert('notes', note.asMap());
  }

  Future<void> softDelete(int id) async {
    var db = await _dbContext.database;
    await db?.rawUpdate("UPDATE notes SET isDeleted = 1, edited = datetime('now') WHERE id = ?", [id]);
  }

  Future<void> restore(int id) async {
    var db = await _dbContext.database;
    await db?.rawUpdate("UPDATE notes SET isArchived = 0, isDeleted = 0, edited = datetime('now') WHERE id = ?", [id]);
  }

  Future<void> deletePermanently(int id) async {
    var db = await _dbContext.database;
    await db?.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> archive(int id) async {
    var db = await _dbContext.database;
    await db?.rawUpdate("UPDATE notes SET isArchived = 1, edited = datetime('now') WHERE id = ?", [id]);
  }

  Future<void> unarchive(int id) async {
    var db = await _dbContext.database;
    await db?.rawUpdate("UPDATE notes SET isArchived = 0, isDeleted = 0, edited = datetime('now') WHERE id = ?", [id]);
  }

  Future<void> update(Note note) async {
    var db = await _dbContext.database;
    await db?.update('notes', note.asMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> emptyTrash() async {
    var db = await _dbContext.database;
    await db?.rawDelete("DELETE FROM notes WHERE (isDeleted = 1 AND edited <= datetime('now', '-30 days'))");
  }
}