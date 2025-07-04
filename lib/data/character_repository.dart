import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:simple5e/models/character.dart';

class CharacterRepository {
  static CharacterRepository instance = CharacterRepository._init();
  static Database? _database;

  CharacterRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('characters.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future<void> createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS characters(
        id INTEGER PRIMARY KEY,
        level INTEGER,
        name TEXT,
        race TEXT,
        characterClass TEXT,
        armorClass INTEGER,
        initiative INTEGER,
        speed INTEGER,
        healthPoints INTEGER,
        temporaryPoints INTEGER,
        strength INTEGER,
        dexterity INTEGER,
        constitution INTEGER,
        intelligence INTEGER,
        wisdom INTEGER,
        charisma INTEGER,
        hitDice TEXT,
        deathSaves INTEGER,
        dexSave INTEGER,
        strSave INTEGER,
        conSave INTEGER,
        intSave INTEGER,
        wisSave INTEGER,
        chaSave INTEGER,
        proficiencyBonus INTEGER,
        inspiration INTEGER,
        acrobatics INTEGER,
        sleightOfHand INTEGER,
        stealth INTEGER,
        animalHandling INTEGER,
        insight INTEGER,
        medicine INTEGER,
        perception INTEGER,
        survival INTEGER,
        athletics INTEGER,
        intimidation INTEGER,
        performance INTEGER,
        persuasion INTEGER,
        arcana INTEGER,
        history INTEGER,
        deception INTEGER,
        investigation INTEGER,
        nature INTEGER,
        religion INTEGER,
        assetUri TEXT
      )
    ''');
  }

  Future<void> clearDB() async {
    final db = await database;
    await db.execute('DELETE FROM characters');
    await db.execute('DROP TABLE characters');
  }

  Future<int> createCharacter(Character character) async {
    final db = await database;
    return await db.insert('characters', _characterToMap(character));
  }

  Future<int> getNextCharacterId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT MAX(id) FROM characters');
    if (result.first.values.first == null) {
      return 0;
    }
    final id = result.first.values.first as int;
    return id + 1;
  }

  Future<Character?> readCharacter(int id) async {
    final db = await database;
    final maps = await db.query(
      'characters',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToCharacter(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Character>> readAllCharacters() async {
    final db = await database;
    const orderBy = 'name ASC';
    final result = await db.query('characters', orderBy: orderBy);

    return result.map((map) => _mapToCharacter(map)).toList();
  }

  Future<int> updateCharacter(Character character) async {
    final db = await database;
    return db.update(
      'characters',
      _characterToMap(character),
      where: 'id = ?',
      whereArgs: [character.id],
    );
  }

  Future<int> updateCharacterStat<T>(
      int id, String statName, T newValue) async {
    final db = await database;
    String columnName = _getColumnNameForStat(statName);
    return db.update(
      'characters',
      {columnName: newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  String _getColumnNameForStat(String statName) {
    switch (statName) {
      case 'Armor Class':
      case 'AC':
        return 'armorClass';
      case 'Initiative':
        return 'initiative';
      case 'Speed':
        return 'speed';
      case 'Health Points':
      case 'HP':
        return 'healthPoints';
      case 'Temporary Points':
        return 'temporaryPoints';
      case 'Strength':
        return 'strength';
      case 'Dexterity':
        return 'dexterity';
      case 'Constitution':
        return 'constitution';
      case 'Intelligence':
        return 'intelligence';
      case 'Wisdom':
        return 'wisdom';
      case 'Charisma':
        return 'charisma';
      case 'Hit Dice':
        return 'hitDice';
      case 'Death Saves':
        return 'deathSaves';
      case 'Dexterity Save':
        return 'dexSave';
      case 'Strength Save':
        return 'strSave';
      case 'Constitution Save':
        return 'conSave';
      case 'Intelligence Save':
        return 'intSave';
      case 'Wisdom Save':
        return 'wisSave';
      case 'Charisma Save':
        return 'chaSave';
      case 'Proficiency Bonus':
        return 'proficiencyBonus';
      case 'Inspiration':
        return 'inspiration';
      case 'Acrobatics':
        return 'acrobatics';
      case 'Sleight of Hand':
        return 'sleightOfHand';
      case 'Stealth':
        return 'stealth';
      case 'Animal Handling':
        return 'animalHandling';
      case 'Insight':
        return 'insight';
      case 'Medicine':
        return 'medicine';
      case 'Perception':
        return 'perception';
      case 'Survival':
        return 'survival';
      case 'Athletics':
        return 'athletics';
      case 'Intimidation':
        return 'intimidation';
      case 'Performance':
        return 'performance';
      case 'Persuasion':
        return 'persuasion';
      case 'Deception':
        return 'deception';
      case 'Arcana':
        return 'arcana';
      case 'History':
        return 'history';
      case 'Investigation':
        return 'investigation';
      case 'Nature':
        return 'nature';
      case 'Religion':
        return 'religion';
      case 'Level':
        return 'level';
      case 'Temporary':
        return 'temporaryPoints';
      default:
        throw ArgumentError('Invalid stat name: $statName');
    }
  }

  Future<int> deleteCharacter(int id) async {
    final db = await database;
    return await db.delete(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _characterToMap(Character character) {
    return {
      'id': character.id,
      'level': character.level,
      'name': character.name,
      'race': character.race,
      'characterClass': character.characterClass,
      'armorClass': character.armorClass,
      'initiative': character.initiative,
      'speed': character.speed,
      'healthPoints': character.healthPoints,
      'temporaryPoints': character.temporaryPoints,
      'strength': character.strength,
      'dexterity': character.dexterity,
      'constitution': character.constitution,
      'intelligence': character.intelligence,
      'wisdom': character.wisdom,
      'charisma': character.charisma,
      'hitDice': character.hitDice,
      'deathSaves': character.deathSaves,
      'dexSave': character.dexSave,
      'strSave': character.strSave,
      'conSave': character.conSave,
      'intSave': character.intSave,
      'wisSave': character.wisSave,
      'chaSave': character.chaSave,
      'proficiencyBonus': character.proficiencyBonus,
      'inspiration': character.inspiration,
      'acrobatics': character.acrobatics,
      'sleightOfHand': character.sleightOfHand,
      'stealth': character.stealth,
      'animalHandling': character.animalHandling,
      'insight': character.insight,
      'deception': character.deception,
      'medicine': character.medicine,
      'perception': character.perception,
      'survival': character.survival,
      'athletics': character.athletics,
      'intimidation': character.intimidation,
      'performance': character.performance,
      'persuasion': character.persuasion,
      'arcana': character.arcana,
      'history': character.history,
      'investigation': character.investigation,
      'nature': character.nature,
      'religion': character.religion,
      'assetUri': character.assetUri,
    };
  }

  Character _mapToCharacter(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      level: map['level'] as int,
      name: map['name'] as String,
      race: map['race'] as String,
      characterClass: map['characterClass'] as String,
      armorClass: map['armorClass'] as int,
      initiative: map['initiative'] as int,
      speed: map['speed'] as int,
      healthPoints: map['healthPoints'] as int,
      temporaryPoints: map['temporaryPoints'] as int,
      strength: map['strength'] as int,
      dexterity: map['dexterity'] as int,
      constitution: map['constitution'] as int,
      intelligence: map['intelligence'] as int,
      wisdom: map['wisdom'] as int,
      charisma: map['charisma'] as int,
      hitDice: map['hitDice'] as String,
      deathSaves: map['deathSaves'] as int,
      dexSave: map['dexSave'] as int,
      strSave: map['strSave'] as int,
      conSave: map['conSave'] as int,
      intSave: map['intSave'] as int,
      wisSave: map['wisSave'] as int,
      chaSave: map['chaSave'] as int,
      deception: map['deception'] as int,
      proficiencyBonus: map['proficiencyBonus'] as int,
      inspiration: map['inspiration'] as int,
      acrobatics: map['acrobatics'] as int,
      sleightOfHand: map['sleightOfHand'] as int,
      stealth: map['stealth'] as int,
      animalHandling: map['animalHandling'] as int,
      insight: map['insight'] as int,
      medicine: map['medicine'] as int,
      perception: map['perception'] as int,
      survival: map['survival'] as int,
      athletics: map['athletics'] as int,
      intimidation: map['intimidation'] as int,
      performance: map['performance'] as int,
      persuasion: map['persuasion'] as int,
      arcana: map['arcana'] as int,
      history: map['history'] as int,
      investigation: map['investigation'] as int,
      nature: map['nature'] as int,
      religion: map['religion'] as int,
      assetUri: map['assetUri'] as String,
    );
  }
}
