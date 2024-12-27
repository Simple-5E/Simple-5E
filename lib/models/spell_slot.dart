class SpellSlot {
  final int id;
  final int characterId;
  final int level;
  final int total;
  final int used;

  SpellSlot({
    required this.id,
    required this.characterId,
    required this.level,
    required this.total,
    required this.used,
  });

  factory SpellSlot.fromMap(Map<String, dynamic> map) {
    return SpellSlot(
      id: map['id'] as int,
      characterId: map['characterId'] as int,
      level: map['level'] as int,
      total: map['total'] as int,
      used: map['used'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'characterId': characterId,
      'level': level,
      'total': total,
      'used': used,
    };
  }

  SpellSlot copyWith({
    int? id,
    int? characterId,
    int? level,
    int? total,
    int? used,
  }) {
    return SpellSlot(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      level: level ?? this.level,
      total: total ?? this.total,
      used: used ?? this.used,
    );
  }
}
