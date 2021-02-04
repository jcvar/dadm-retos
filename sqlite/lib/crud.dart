import 'package:sqflite/sqflite.dart';
import 'package:sqlite/company.dart';
import 'package:sqlite/db.dart';

class CrudCompany {
  // CREATE
  static Future<void> createComp(Company comp) async {
    final data = await db.insert(DatabaseCreator.companyTable, comp.toMap());
    DatabaseCreator.databaseLog('createComp', 'insert', null, data);
  }

  // READ ALL
  static Future<List<Company>> readAllComps() async {
    final data = await db.query(DatabaseCreator.companyTable);
    List<Company> companies = List();
    for (final d in data) {
      var comp = Company.fromJson(d);
      companies.add(comp);
    }
    return companies;
  }

  // READ
  static Future<Company> readComp(int id) async {
    final data = await db.query(DatabaseCreator.companyTable,
        where: '${DatabaseCreator.id} == ?', whereArgs: [id]);
    final comp = Company.fromJson(data[0]);
    return comp;
  }

  // UPDATE
  static Future<void> updateComp(Company comp) async {
    final data = await db.update(DatabaseCreator.companyTable, comp.toMap(),
        where: '${DatabaseCreator.id} == ?', whereArgs: [comp.id]);
    DatabaseCreator.databaseLog('updateComp', 'update', null, data);
  }

  // DELETE
  static Future<void> deleteComp(int id) async {
    final data = await db.delete(DatabaseCreator.companyTable,
        where: '${DatabaseCreator.id} == ?', whereArgs: [id]);
    DatabaseCreator.databaseLog('deleteComp', 'delete', null, data);
  }

  // EXTRA: COUNT
  static Future<int> compCount() async {
    final data = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM ${DatabaseCreator.companyTable}'));
    return data;
  }
}
