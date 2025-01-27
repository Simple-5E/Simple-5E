class Spell {
  final String name;
  final String level;
  final List<String> classes;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final String description;
  final String? additionalNotes;
  final bool isUserDefined;

  Spell({
    required this.name,
    required this.level,
    required this.classes,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.description,
    this.additionalNotes,
    this.isUserDefined = false,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      name: json['name'],
      level: json['level'],
      classes: List<String>.from(json['classes']),
      castingTime: json['castingTime'],
      range: json['range'],
      components: json['components'],
      duration: json['duration'],
      description: json['description'],
      additionalNotes: json['additionalNotes'],
    );
  }
}
