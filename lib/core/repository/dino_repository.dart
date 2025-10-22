// lib/core/repository/dino_repository.dart
import 'package:sqflite/sqflite.dart';
import '../../features/dino/models/dinosaur.dart';
import '../db/dino_db.dart';

class DinoRepository {
  Future<int> create(Dinosaur d) async {
    final db = await DinoDb().database;
    return db.insert('dinosaurs', d.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Dinosaur>> list({String? q, String? diet, bool? favorite}) async {
    final db = await DinoDb().database;
    final where = <String>[];
    final args = <dynamic>[];

    if (q != null && q.isNotEmpty) {
      where.add('(name LIKE ? OR period LIKE ? OR diet LIKE ?)');
      args.addAll(['%$q%', '%$q%', '%$q%']);
    }
    if (diet != null && diet.isNotEmpty) {
      where.add('diet = ?'); args.add(diet);
    }
    if (favorite != null) {
      where.add('favorite = ?'); args.add(favorite ? 1 : 0);
    }

    final rows = await db.query(
      'dinosaurs',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'favorite DESC, created_at DESC',
    );
    return rows.map(Dinosaur.fromMap).toList();
  }

  Future<int> update(Dinosaur d) async {
    final db = await DinoDb().database;
    return db.update('dinosaurs', d.toMap(), where: 'id = ?', whereArgs: [d.id]);
  }

  Future<int> delete(int id) async {
    final db = await DinoDb().database;
    return db.delete('dinosaurs', where: 'id = ?', whereArgs: [id]);
  }
}
