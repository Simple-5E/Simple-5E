import 'package:simple5e/data/character_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simple5e/models/race.dart';

class RaceRepository {
  static final RaceRepository instance = RaceRepository._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  RaceRepository._init();

  Future<Database> get database async => await _characterRepository.database;

  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS races(
        name TEXT PRIMARY KEY,
        description TEXT,
        abilityScoreIncrease TEXT,
        speed TEXT,
        size TEXT,
        languages TEXT,
        age TEXT,
        alignment TEXT
      )
    ''');

    // Create race_abilities table using race name as foreign key
    await db.execute('''
      CREATE TABLE IF NOT EXISTS race_abilities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        raceName TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (raceName) REFERENCES races (name) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> clearDB() async {
    final db = await database;
    await db.execute('DELETE FROM race_abilities');
    await db.execute('DELETE FROM races');
    await db.execute('DROP TABLE race_abilities');
    await db.execute('DROP TABLE races');
  }

  Future<String> createRace(Race race) async {
    final db = await database;

    return await db.transaction((txn) async {
      await txn.insert('races', _raceToMap(race),
          conflictAlgorithm: ConflictAlgorithm.replace);

      for (final ability in race.abilities) {
        await txn.insert('race_abilities', {
          'raceName': race.name,
          'name': ability.name,
          'description': ability.description,
        });
      }

      return race.name;
    });
  }

  Future<Race?> readRace(String name) async {
    final db = await database;

    // Get the race
    final raceMaps = await db.query(
      'races',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (raceMaps.isEmpty) return null;

    final abilityMaps = await db.query(
      'race_abilities',
      where: 'raceName = ?',
      whereArgs: [name],
    );

    final abilities = abilityMaps
        .map((map) => RaceAbility(
              name: map['name'] as String,
              description: map['description'] as String,
            ))
        .toList();
    return _mapToRace(raceMaps.first, abilities);
  }

  Future<List<Race>> readAllRaces() async {
    final db = await database;
    final races = await db.query('races', orderBy: 'name ASC');

    List<Race> raceList = [];

    for (final raceMap in races) {
      final name = raceMap['name'] as String;
      final abilities = await db.query(
        'race_abilities',
        where: 'raceName = ?',
        whereArgs: [name],
      );

      final raceAbilities = abilities
          .map((map) => RaceAbility(
                name: map['name'] as String,
                description: map['description'] as String,
              ))
          .toList();

      raceList.add(_mapToRace(raceMap, raceAbilities));
    }

    return raceList;
  }

  Future<int> updateRace(Race race) async {
    final db = await database;

    return await db.transaction((txn) async {
      await txn.update(
        'races',
        _raceToMap(race),
        where: 'name = ?',
        whereArgs: [race.name],
      );

      await txn.delete(
        'race_abilities',
        where: 'raceName = ?',
        whereArgs: [race.name],
      );

      for (final ability in race.abilities) {
        await txn.insert('race_abilities', {
          'raceName': race.name,
          'name': ability.name,
          'description': ability.description,
        });
      }

      return 1;
    });
  }

  Future<int> deleteRace(String name) async {
    final db = await database;
    return await db.delete(
      'races',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Map<String, dynamic> _raceToMap(Race race) {
    return {
      'name': race.name,
      'description': race.description,
      'abilityScoreIncrease': race.abilityScoreIncrease,
      'speed': race.speed,
      'size': race.size,
      'languages': race.languages,
      'age': race.age,
      'alignment': race.alignment,
    };
  }

  Race _mapToRace(Map<String, dynamic> map, List<RaceAbility> abilities) {
    return Race(
      name: map['name'] as String,
      description: map['description'] as String,
      abilityScoreIncrease: map['abilityScoreIncrease'] as String,
      speed: map['speed'] as String,
      size: map['size'] as String,
      languages: map['languages'] as String,
      age: map['age'] as String,
      alignment: map['alignment'] as String,
      abilities: abilities,
    );
  }
}
