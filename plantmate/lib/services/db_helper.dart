import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/plant.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plantmate.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plants(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            planted_date TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  /// 식물 추가
  Future<int> insertPlant(Plant plant) async {
    final client = await db;
    return client.insert('plants', plant.toMap());
  }

  /// 저장된 모든 식물 조회
  Future<List<Plant>> fetchAllPlants() async {
    final client = await db;
    final maps = await client.query(
      'plants',
      orderBy: 'id DESC',
    );
    return maps.map((m) => Plant.fromMap(m)).toList();
  }

  /// 식물 삭제
  Future<int> deletePlant(int id) async {
    final client = await db;
    return client.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 식물 정보 업데이트 (예: 이름 변경 or 날짜 변경)
  Future<int> updatePlant(Plant plant) async {
    final client = await db;
    return client.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }
}
