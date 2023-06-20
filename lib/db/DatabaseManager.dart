import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:io';

import '../model/address/address_city.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  static DatabaseManager get instance => _instance;

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  Future<void> init() async {
    await createDB();
  }

  Database? _db;

  Database? get db => _db;
  final LocalStorage storage = LocalStorage('app_data');
  bool initialized = false;

  createDB() async {
    getLocalDB();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'local_db.db');
    _db = await openDatabase(databasePath);
  }

  getLocalDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "local_db.db");
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load('assets/config/data.sqlite');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }
  }

  accessDB() async {
    getLocalDB();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'local_db.db');
    _db = await openDatabase(databasePath);
    initialized = true;
  }

  Future<List<City>> queryCity(List<City> cities) async {
    if (_db != null) {
      try {
        List<Map> list = await _db!.rawQuery('SELECT * FROM locations_cities');
        var data = <City>[];
        for (int i = 0; i < list.length; i++) {
          City city = City();
          city.id = int.parse(list[i]["id"]);
          city.name = list[i]["name"];
          data.add(city);
        }
        cities = data;
        return cities;
      } catch (e) {
        print('ERR');
        print(e.toString());
      }
    }
    return [];
  }
}
