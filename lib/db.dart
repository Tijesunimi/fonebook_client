import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'models/contact.dart';

class DatabaseHelper {
  static final _databaseName = "fonebook.db";
  static final _databaseVersion = 1;

  static final table = "contacts";
  static final columnId = "id";
  static final columnAvatar = "avatar";
  static final columnCategory = "category";
  static final columnNames = "names";
  static final columnCompany = "company";
  static final columnPhones = "phones";
  static final columnEmails = "emails";
  static final columnAddresses = "addresses";
  static final columnWebsite = "website";
  static final columnNotes = "notes";
  static final columnBirthDate = "birth_date";
  static final columnCustom = "custom";
  static final columnServerManaged = "is_server_managed";

  DatabaseHelper._initializeHelper();

  static Database _database;
  static final DatabaseHelper instance = DatabaseHelper._initializeHelper();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnAvatar TEXT,
        $columnCategory TEXT,
        $columnNames TEXT,
        $columnCompany TEXT,
        $columnPhones TEXT,
        $columnEmails TEXT,
        $columnAddresses TEXT,
        $columnWebsite TEXT,
        $columnNotes TEXT,
        $columnBirthDate TEXT,
        $columnCustom TEXT,
        $columnServerManaged TEXT
      )
      ''');
  }

  Future<int> insertContact(MainContact contact) async {
    Database db = await instance.database;
    return await db.insert(table, contact.toLocalJson());
  }

  Future<void> syncContacts(List<MainContact> contacts) async {
    Database db = await instance.database;
    var batch  = db.batch();
    contacts.forEach((contact) {
      batch.insert(table, contact.toLocalJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(continueOnError: true);
  }

  Future<List<MainContact>> fetchContacts() async {
    Database db = await instance.database;
    var response = await db.query(table);
    List<MainContact> contacts = response.isNotEmpty ? response.map((c) => MainContact.fromLocalJson(c)).toList() : [];
    return contacts;
  }

  Future<List<MainContact>> fetchUserContacts() async {
    Database db = await instance.database;
    var response = await db.query(table, where: "$columnServerManaged = 'false'");
    List<MainContact> contacts = response.isNotEmpty ? response.map((c) => MainContact.fromLocalJson(c)).toList() : [];
    return contacts;
  }

  Future<int> fetchContactCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> updateContact(MainContact contact) async {
    Database db = await instance.database;
    String id = contact.identifier;
    return await db.update(table, contact.toLocalJson(), where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteContact(String id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}