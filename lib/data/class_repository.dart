import 'package:simple5e/data/character_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simple5e/models/character_class.dart';

class ClassRepository {
  static final ClassRepository instance = ClassRepository._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  ClassRepository._init();

  Future<Database> get database async => await _characterRepository.database;

  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS classes(
        name TEXT PRIMARY KEY,
        description TEXT,
        hitDie TEXT,
        spellcasting TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS class_proficiencies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        className TEXT,
        proficiency TEXT,
        FOREIGN KEY (className) REFERENCES classes (name) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> clearDB() async {
    final db = await database;
    await db.execute('DELETE FROM class_proficiencies');
    await db.execute('DELETE FROM classes');
    await db.execute('DROP TABLE class_proficiencies');
    await db.execute('DROP TABLE classes');
  }

  Future<String> createClass(CharacterClass characterClass) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Insert the class
      await txn.insert('classes', _classToMap(characterClass),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Insert each proficiency
      for (final proficiency in characterClass.proficiencies) {
        await txn.insert('class_proficiencies', {
          'className': characterClass.name,
          'proficiency': proficiency,
        });
      }

      return characterClass.name;
    });
  }

  Future<CharacterClass?> readClass(String name) async {
    final db = await database;

    final classMaps = await db.query(
      'classes',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (classMaps.isEmpty) return null;

    final proficiencyMaps = await db.query(
      'class_proficiencies',
      where: 'className = ?',
      whereArgs: [name],
    );

    final proficiencies =
        proficiencyMaps.map((map) => map['proficiency'] as String).toList();

    return _mapToClass(classMaps.first, proficiencies);
  }

  Future<List<CharacterClass>> readAllClasses() async {
    final db = await database;
    final classes = await db.query('classes', orderBy: 'name ASC');

    List<CharacterClass> classList = [];

    for (final classMap in classes) {
      final name = classMap['name'] as String;
      final proficiencies = await db.query(
        'class_proficiencies',
        where: 'className = ?',
        whereArgs: [name],
      );

      final proficiencyList =
          proficiencies.map((map) => map['proficiency'] as String).toList();

      classList.add(_mapToClass(classMap, proficiencyList));
    }

    return classList;
  }

  Future<int> updateClass(CharacterClass characterClass) async {
    final db = await database;

    return await db.transaction((txn) async {
      await txn.update(
        'classes',
        _classToMap(characterClass),
        where: 'name = ?',
        whereArgs: [characterClass.name],
      );

      await txn.delete(
        'class_proficiencies',
        where: 'className = ?',
        whereArgs: [characterClass.name],
      );

      for (final proficiency in characterClass.proficiencies) {
        await txn.insert('class_proficiencies', {
          'className': characterClass.name,
          'proficiency': proficiency,
        });
      }

      return 1;
    });
  }

  Future<int> deleteClass(String name) async {
    final db = await database;
    return await db.delete(
      'classes',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Map<String, dynamic> _classToMap(CharacterClass characterClass) {
    return {
      'name': characterClass.name,
      'description': characterClass.description,
      'hitDie': characterClass.hitDie,
      'spellcasting': characterClass.spellcasting,
    };
  }

  CharacterClass _mapToClass(
      Map<String, dynamic> map, List<String> proficiencies) {
    return CharacterClass(
      name: map['name'] as String,
      description: map['description'] as String,
      hitDie: map['hitDie'] as String,
      spellcasting: map['spellcasting'] as String,
      proficiencies: proficiencies,
    );
  }
}
