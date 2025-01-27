import 'package:sqflite/sqflite.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/data/character_repository.dart';
import 'dart:convert';

class SpellRepository {
  static SpellRepository instance = SpellRepository._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  SpellRepository._init();

  Future<Database> get database async => await _characterRepository.database;

  Future<void> createSpellTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS spells(
        name TEXT PRIMARY KEY,
        level TEXT,
        classes TEXT,
        castingTime TEXT,
        range TEXT,
        components TEXT,
        duration TEXT,
        description TEXT,
        additionalNotes TEXT,
        isUserDefined INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_spells(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        characterId INTEGER,
        spellName TEXT,
        FOREIGN KEY (characterId) REFERENCES characters (id),
        FOREIGN KEY (spellName) REFERENCES spells (name)
      )
    ''');
  }

  Future<void> createSpell(Spell spell) async {
    final db = await database;
    await db.insert('spells', _spellToMap(spell),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Spell?> readSpell(String name) async {
    final db = await database;
    final maps = await db.query(
      'spells',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return _mapToSpell(maps.first);
    } else {
      return null;
    }
  }

  Future<void> clearDB() async {
    final db = await database;
    await db.execute('DELETE FROM spells');
    await db.execute('DELETE FROM character_spells');
    await db.execute('DROP TABLE spells');
    await db.execute('DROP TABLE character_spells');
  }

  Future<List<Spell>> readAllSpells() async {
    final db = await database;
    final result = await db.query('spells');
    return result.map((map) => _mapToSpell(map)).toList();
  }

  Future<List<Spell>> readAllUserDefinedSpells() async {
    final db = await database;
    final result = await db.query('spells', where: 'isUserDefined = 1');
    return result.map((map) => _mapToSpell(map)).toList();
  }

  Future<void> updateSpell(Spell spell) async {
    final db = await database;
    await db.update(
      'spells',
      _spellToMap(spell),
      where: 'name = ?',
      whereArgs: [spell.name],
    );
  }

  Future<void> deleteSpell(String name) async {
    final db = await database;
    await db.delete(
      'spells',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> addSpellToCharacter(int characterId, String spellName) async {
    final db = await database;
    await db.insert('character_spells', {
      'characterId': characterId,
      'spellName': spellName,
    });
  }

  Future<void> removeSpellFromCharacter(
      int characterId, String spellName) async {
    final db = await database;
    await db.delete(
      'character_spells',
      where: 'characterId = ? AND spellName = ?',
      whereArgs: [characterId, spellName],
    );
  }

  Future<void> clearSpellsForCharacter(int characterId) async {
    final db = await database;
    await db.delete(
      'character_spells',
      where: 'characterId = ?',
      whereArgs: [characterId],
    );
  }

  Future<List<Spell>> readSpellsForCharacter(int characterId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT s.*
      FROM spells s
      INNER JOIN character_spells cs ON s.name = cs.spellName
      WHERE cs.characterId = ?
    ''', [characterId]);

    return result.map((map) => _mapToSpell(map)).toList();
  }

  Map<String, dynamic> _spellToMap(Spell spell) {
    return {
      'name': spell.name,
      'level': spell.level,
      'classes': jsonEncode(spell.classes),
      'castingTime': spell.castingTime,
      'range': spell.range,
      'components': spell.components,
      'duration': spell.duration,
      'description': spell.description,
      'additionalNotes': spell.additionalNotes,
      'isUserDefined': spell.isUserDefined ? 1 : 0,
    };
  }

  Spell _mapToSpell(Map<String, dynamic> map) {
    return Spell(
      name: map['name'] as String,
      level: map['level'] as String,
      classes: List<String>.from(jsonDecode(map['classes'])),
      castingTime: map['castingTime'] as String,
      range: map['range'] as String,
      components: map['components'] as String,
      duration: map['duration'] as String,
      description: map['description'] as String,
      additionalNotes: map['additionalNotes'] as String?,
      isUserDefined: map['isUserDefined'] == 1,
    );
  }
}
