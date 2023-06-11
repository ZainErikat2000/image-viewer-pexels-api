import 'package:flutter/cupertino.dart';
import 'package:josequal/models/image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<void> createTable(sql.Database db) async {
    await db.execute("""
    CREATE TABLE fav(
    id INTEGER PRIMARY KEY NOT NULL,
    src TEXT NOT NULL,
    landscape TEXT NOT NULL,
    small TEXT NOT NULL,
    owner TEXT NOT NULL)
    """);
  }

  static Future<sql.Database> db() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path,'fav.db');

    return sql.openDatabase(path, version: 1,
        onCreate: (sql.Database db, int version) async {
      await createTable(db);
    });
  }

  static Future<void> createImage(ImageModel image) async {
    final db = await DatabaseHelper.db();
    final data = {
      'id': image.id,
      'src': image.src,
      'landscape': image.landscapeSrc,
      'small': image.small,
      'owner': image.owner
    };

    await db.insert('fav', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getImages() async {
    final db = await DatabaseHelper.db();
    return db.query('fav', orderBy: 'id');
  }

  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('fav', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> findFav(int id) async {
    final db = await DatabaseHelper.db();
    List<dynamic> query =
        await db.query('fav', where: 'id = ?', whereArgs: [id]);
    if (query.length == 0) {
      return false;
    } else {
      return true;
    }
  }
}
