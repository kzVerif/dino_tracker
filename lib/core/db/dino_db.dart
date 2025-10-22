// lib/core/db/dino_db.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DinoDb {
  static final DinoDb _i = DinoDb._internal();
  factory DinoDb() => _i;
  DinoDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'dino.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE dinosaurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            period TEXT NOT NULL,
            diet TEXT NOT NULL,
            length_m REAL,
            weight_tons REAL,
            favorite INTEGER NOT NULL DEFAULT 0,
            note TEXT,
            created_at TEXT NOT NULL
          )
        ''');
        // seed ตัวอย่าง
        await db.insert('dinosaurs', {
          'name': 'Tyrannosaurus rex',
          'period': 'Late Cretaceous',
          'diet': 'carnivore',
          'length_m': 12.3,
          'weight_tons': 8.4,
          'favorite': 1,
          'note': 'King of the tyrant lizards',
          'created_at': DateTime.now().toIso8601String(),
        });
      },
    );
    return _db!;
  }
}
