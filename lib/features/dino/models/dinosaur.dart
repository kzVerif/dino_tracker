// lib/features/dino/models/dinosaur.dart
class Dinosaur {
  final int? id;
  final String name;
  final String period;
  final String diet; // 'carnivore' | 'herbivore' | 'omnivore'
  final double? lengthM;
  final double? weightTons;
  final bool favorite;
  final String? note;
  final DateTime createdAt;

  Dinosaur({
    this.id,
    required this.name,
    required this.period,
    required this.diet,
    this.lengthM,
    this.weightTons,
    this.favorite = false,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'period': period,
    'diet': diet,
    'length_m': lengthM,
    'weight_tons': weightTons,
    'favorite': favorite ? 1 : 0,
    'note': note,
    'created_at': createdAt.toIso8601String(),
  };

  factory Dinosaur.fromMap(Map<String, dynamic> m) => Dinosaur(
    id: m['id'] as int?,
    name: m['name'],
    period: m['period'],
    diet: m['diet'],
    lengthM: (m['length_m'] as num?)?.toDouble(),
    weightTons: (m['weight_tons'] as num?)?.toDouble(),
    favorite: (m['favorite'] ?? 0) == 1,
    note: m['note'],
    createdAt: DateTime.parse(m['created_at']),
  );

  Dinosaur copyWith({
    int? id,
    String? name,
    String? period,
    String? diet,
    double? lengthM,
    double? weightTons,
    bool? favorite,
    String? note,
    DateTime? createdAt,
  }) => Dinosaur(
    id: id ?? this.id,
    name: name ?? this.name,
    period: period ?? this.period,
    diet: diet ?? this.diet,
    lengthM: lengthM ?? this.lengthM,
    weightTons: weightTons ?? this.weightTons,
    favorite: favorite ?? this.favorite,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
}
