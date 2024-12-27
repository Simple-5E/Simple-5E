class CharacterClass {
  final String name;
  final String description;
  final String hitDie;
  final List<String> proficiencies;
  final String spellcasting;

  CharacterClass({
    required this.name,
    required this.description,
    required this.hitDie,
    required this.proficiencies,
    required this.spellcasting,
  });
}
