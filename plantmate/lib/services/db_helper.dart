import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/plant.dart';
import '../models/variety.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plantmate.db');
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(_createTable);
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute('DROP TABLE IF EXISTS plants');
          await db.execute(_createTable);
        }
      },
    );
    return _db!;
  }

  static const String _createTable = '''
    CREATE TABLE plants(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      variety TEXT NOT NULL,
      planted_date TEXT NOT NULL,
      temperature REAL,
      brightness REAL,
      humidity REAL,
      tank_level REAL,
      tray_height REAL
    )
  ''';

  Future<int> insertPlant(Plant p) async {
    final dbClient = await db;
    return dbClient.insert('plants', p.toMap());
  }

  Future<List<Plant>> fetchAllPlants() async {
    final dbClient = await db;
    final rows = await dbClient.query('plants', orderBy: 'id DESC');
    return rows.map((m) => Plant.fromMap(m)).toList();
  }

  Future<int> deletePlant(int id) async {
    final dbClient = await db;
    return dbClient.delete('plants', where: 'id = ?', whereArgs: [id]);
  }

  /// 식물 정보 업데이트
  Future<int> updatePlant(Plant p) async {
    final dbClient = await db;
    return dbClient.update(
      'plants',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<VarietyDefault> fetchVarietyDefaults(String variety) async {
    final dbClient = await db; // your getter that opens the DB
    final result = await dbClient.query(
      'variety_defaults',
      where: 'variety = ?',
      whereArgs: [variety],
    );
    if (result.isEmpty) {
      throw Exception('Defaults not found for variety $variety');
    }
    return VarietyDefault.fromMap(result.first);
  }
}
