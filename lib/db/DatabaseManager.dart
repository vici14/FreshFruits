import 'package:flutter/services.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/model/address/AdressWards.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:io';

import '../model/address/AddressCity.dart';

class DatabaseManager {
  static late DatabaseManager _instance;

  static DatabaseManager get instance => _instance;

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  static Future<void> init() async {
    _instance = DatabaseManager._internal();
    await createDB();
  }

  static Database? _db;

  Database? get db => _db;
  final LocalStorage storage = LocalStorage('app_data');
  bool initialized = false;

  static createDB() async {
    getLocalDB();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'local_db.db');
    _db = await openDatabase(databasePath);
  }

  static getLocalDB() async {
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

  Future<List<District>> queryDistrict() async {
    ///HoChiMinh cityId = 79
    String cityId = "79";
    if (_db != null) {
      try {
        List<Map> list = await _db!
            .rawQuery('SELECT * FROM locations_districts WHERE city_id="79"');
        var data = <District>[];
        for (int i = 0; i < list.length; i++) {
          District district = District();
          district.id = int.parse(list[i]["id"]);
          district.name = list[i]["name"];
          data.add(district);
        }
      data =   sortDistrict(data);
        return data;
      } catch (e) {
        print('ERR');
        print(e.toString());
      }
    }
    return [];
  }

  List<District> sortDistrict(List<District> districts) {
    List<District> _list = [];
    List<District> _listCharacter = [];
    for (var district in districts) {
      if (int.tryParse(district.name!) != null) {
        _list.add(district);
       }else{
        _listCharacter.add(district);
      }
      _list.sort(
        (a, b) {
          return int.parse(a.name ?? "").compareTo(int.parse(b.name ?? ""));
        },
      );

     }
    _list.addAll(_listCharacter);
    return _list;
  }

  List<Ward> sortWard(List<Ward> wards) {
    List<Ward> _list = [];
    List<Ward> _listCharacter = [];
    for (var ward in wards) {
      if (int.tryParse(ward.name!) != null) {
        _list.add(ward);
      }else{
        _listCharacter.add(ward);
      }
      _list.sort(
            (a, b) {
          return int.parse(a.name ?? "").compareTo(int.parse(b.name ?? ""));
        },
      );

    }
    _list.addAll(_listCharacter);
    return _list;
  }

  Future<List<Ward>> queryWard(String districtId) async {
    if (_db != null) {
      try {
        List<Map> list = await _db!.rawQuery('SELECT * FROM '
            'locations_wards WHERE district_id="$districtId"');
        var data = <Ward>[];
        for (int i = 0; i < list.length; i++) {
          Ward ward = Ward();
          ward.id = int.parse(list[i]["id"]);
          ward.name = list[i]["name"];
          data.add(ward);
        }
        data =sortWard(data);
        return data;
      } catch (e) {
        print('ERR');
        print(e.toString());
      }
    }
    return [];
  }
}
