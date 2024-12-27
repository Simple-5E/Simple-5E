class Character {
  final int id;
  final int level;
  final String name;
  final String race;
  final String characterClass;
  final int armorClass;
  final int initiative;
  final int speed;
  final int healthPoints;
  final int temporaryPoints;
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;
  final String hitDice;
  final int deathSaves;

  final int dexSave;
  final int strSave;
  final int conSave;
  final int intSave;
  final int wisSave;
  final int chaSave;
  final int proficiencyBonus;
  final int inspiration;

  final int acrobatics;
  final int sleightOfHand;
  final int stealth;

  final int animalHandling;
  final int insight;
  final int medicine;
  final int perception;
  final int survival;

  final int athletics;

  final int intimidation;
  final int performance;
  final int persuasion;
  final int deception;

  final int arcana;
  final int history;
  final int investigation;
  final int nature;
  final int religion;
  final String assetUri;

  Character({
    required this.id,
    required this.level,
    required this.name,
    required this.race,
    required this.characterClass,
    required this.armorClass,
    required this.initiative,
    required this.speed,
    required this.healthPoints,
    required this.temporaryPoints,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.hitDice,
    required this.deathSaves,
    required this.dexSave,
    required this.strSave,
    required this.conSave,
    required this.intSave,
    required this.wisSave,
    required this.chaSave,
    required this.proficiencyBonus,
    required this.inspiration,
    required this.acrobatics,
    required this.sleightOfHand,
    required this.stealth,
    required this.animalHandling,
    required this.insight,
    required this.medicine,
    required this.perception,
    required this.survival,
    required this.athletics,
    required this.intimidation,
    required this.performance,
    required this.persuasion,
    required this.deception,
    required this.arcana,
    required this.history,
    required this.investigation,
    required this.nature,
    required this.religion,
    required this.assetUri,
  });
}
