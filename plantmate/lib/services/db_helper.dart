import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/plant.dart';
import '../models/variety_defaults.dart';
import '../models/sensor_log.dart';
import '../models/actuator_log.dart';
import '../models/alert_log.dart';

class DBHelper {
  static Database? _instance;

  Future<Database> get database async {
    if (_instance != null) return _instance!;
    final path = join(await getDatabasesPath(), 'plantmate.db');
    _instance = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      // onUpgrade: handle schema migrations...
    );
    return _instance!;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // 품종별 권장 환경 정보
    await db.execute('''
      CREATE TABLE variety_defaults (
        variety TEXT PRIMARY KEY,
        asset_path TEXT,
        temp_min REAL,
        temp_max REAL,
        bright_min REAL,
        bright_max REAL,
        hum_min REAL,
        hum_max REAL,
        water_cycle_days INTEGER
      )
    ''');
    final defaults = [
      {'variety':'상추','asset_path':'assets/icons/lettuce.png','temp_min':15,'temp_max':22,'bright_min':5000,'bright_max':10000,'hum_min':60,'hum_max':80,'water_cycle_days':3},
      {'variety':'딸기','asset_path':'assets/icons/strawberry.png','temp_min':18,'temp_max':26,'bright_min':8000,'bright_max':15000,'hum_min':65,'hum_max':85,'water_cycle_days':2},
      {'variety':'토마토','asset_path':'assets/icons/tomato.png','temp_min':20,'temp_max':30,'bright_min':10000,'bright_max':20000,'hum_min':55,'hum_max':75,'water_cycle_days':2},
    ];
    for (var row in defaults) {
      await db.insert('variety_defaults', row);
    }

    // 현재 키우는 식물 정보
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        variety TEXT,
        planted_date TEXT,
        temperature REAL,
        brightness REAL,
        humidity REAL,
        tank_level REAL,
        tray_height REAL
      )
    ''');

    // 센서 로그 (온도, 밝기, 습도, 등) 기록
    await db.execute('''
      CREATE TABLE sensor_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id INTEGER,
        timestamp TEXT,
        temperature REAL,
        brightness REAL,
        humidity REAL,
        FOREIGN KEY(plant_id) REFERENCES plants(id)
      )
    ''');

    // 액추에이터 동작 로그
    await db.execute('''
      CREATE TABLE actuator_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id INTEGER,
        timestamp TEXT,
        action TEXT,
        FOREIGN KEY(plant_id) REFERENCES plants(id)
      )
    ''');

    // 물통 알림 로그
    await db.execute('''
      CREATE TABLE alert_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id INTEGER,
        timestamp TEXT,
        alert_type TEXT,
        message TEXT,
        FOREIGN KEY(plant_id) REFERENCES plants(id)
      )
    ''');
  }

  // 품종별 권장 환경 읽기
  Future<VarietyDefault> fetchVarietyDefaults(String variety) async {
    final db = await database;
    final res = await db.query(
      'variety_defaults',
      where: 'variety = ?',
      whereArgs: [variety],
    );
    if (res.isEmpty) throw Exception('Defaults not found for $variety');
    return VarietyDefault.fromMap(res.first);
  }
  Future<List<VarietyDefault>> fetchAllVarietyDefaults() async {
    final db = await database;
    final rows = await db.query('variety_defaults');
    return rows.map((m) => VarietyDefault.fromMap(m)).toList();
  }

  // 식물 CRUD
  Future<int> insertPlant(Plant p) async {
    final db = await database;
    return db.insert('plants', p.toMap());
  }
  Future<int> updatePlant(Plant p) async {
    final db = await database;
    return db.update('plants', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }
  Future<int> deletePlant(int id) async {
    final db = await database;
    return db.delete('plants', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<Plant>> fetchAllPlants() async {
    final db = await database;
    final rows = await db.query('plants');
    return rows.map((m) => Plant.fromMap(m)).toList();
  }

  // 센서 로그 관리
  Future<int> insertSensorLog(SensorLog log) async {
    final db = await database;
    return db.insert('sensor_logs', log.toMap());
  }
  Future<List<SensorLog>> fetchSensorLogs(int plantId) async {
    final db = await database;
    final rows = await db.query('sensor_logs', where: 'plant_id = ?', whereArgs: [plantId]);
    return rows.map((m) => SensorLog.fromMap(m)).toList();
  }

  // 액추에이터 로그
  Future<int> insertActuatorLog(ActuatorLog log) async {
    final db = await database;
    return db.insert('actuator_logs', log.toMap());
  }
  Future<List<ActuatorLog>> fetchActuatorLogs(int plantId) async {
    final db = await database;
    final rows = await db.query('actuator_logs', where: 'plant_id = ?', whereArgs: [plantId]);
    return rows.map((m) => ActuatorLog.fromMap(m)).toList();
  }

  // 알림 로그
  Future<int> insertAlertLog(AlertLog log) async {
    final db = await database;
    return db.insert('alert_logs', log.toMap());
  }
  Future<List<AlertLog>> fetchAlertLogs(int plantId) async {
    final db = await database;
    final rows = await db.query('alert_logs', where: 'plant_id = ?', whereArgs: [plantId]);
    return rows.map((m) => AlertLog.fromMap(m)).toList();
  }
}
