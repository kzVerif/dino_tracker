// lib/features/dino/providers/dino_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/repository/dino_repository.dart';
import '../models/dinosaur.dart';

class DinoProvider extends ChangeNotifier {
  final _repo = DinoRepository();
  List<Dinosaur> _items = [];
  String _query = '';
  String _dietFilter = '';
  bool? _favOnly;

  List<Dinosaur> get items => _items;
  String get query => _query;

  Future<void> fetch() async {
    _items = await _repo.list(q: _query, diet: _dietFilter, favorite: _favOnly);
    notifyListeners();
  }

  Future<void> add(Dinosaur d) async {
    await _repo.create(d);
    await fetch();
  }

  Future<void> edit(Dinosaur d) async {
    await _repo.update(d);
    await fetch();
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setQuery(String q) { _query = q; fetch(); }
  void setDietFilter(String diet) { _dietFilter = diet; fetch(); }
  void setFavOnly(bool? fav) { _favOnly = fav; fetch(); }
}
