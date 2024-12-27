// race_model.dart
class RaceAbility {
  final String name;
  final String description;

  RaceAbility({required this.name, required this.description});

  factory RaceAbility.fromJson(Map<String, dynamic> json) {
    return RaceAbility(
      name: json['name'],
      description: json['description'],
    );
  }
}

class Race {
  final String name;
  final String description;
  final String abilityScoreIncrease;
  final String age;
  final String alignment;
  final String size;
  final String speed;
  final String languages;
  final List<RaceAbility> abilities;

  Race({
    required this.name,
    required this.description,
    required this.abilityScoreIncrease,
    required this.age,
    required this.alignment,
    required this.size,
    required this.speed,
    required this.languages,
    required this.abilities,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    var abilitiesList = (json['abilities'] as List)
        .map((ability) => RaceAbility.fromJson(ability))
        .toList();

    return Race(
      name: json['name'],
      description: json['description'],
      abilityScoreIncrease: json['abilityScoreIncrease'],
      age: json['age'],
      alignment: json['alignment'],
      size: json['size'],
      speed: json['speed'],
      languages: json['languages'],
      abilities: abilitiesList,
    );
  }
}
