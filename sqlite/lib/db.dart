import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const companyTable = 'company';
  static const id = 'id';
  static const name = 'name';
  static const url = 'url';
  static const tel = 'tel';
  static const email = 'email';
  static const products = 'products';
  static const classification = 'classification';

  static void databaseLog(String functName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertQueryResult]) {
    if (selectQueryResult != null) {
      print('funct: $functName, sql: $sql, result: $selectQueryResult');
    } else if (insertQueryResult != null) {
      print('funct: $functName, sql: $sql, result: $insertQueryResult');
    }
  }

  Future<void> createTable(Database db) async {
    final companySql = '''CREATE TABLE $companyTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT,
      $url TEXT,
      $tel TEXT,
      $email TEXT,
      $products TEXT,
      $classification TEXT
    )''';
    await db.execute(companySql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
      // await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('dadm_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTable(db);
  }
}
