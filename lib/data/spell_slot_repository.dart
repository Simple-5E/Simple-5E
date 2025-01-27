import 'package:sqflite/sqflite.dart';
import 'package:simple5e/models/spell_slot.dart';
import 'package:simple5e/data/character_repository.dart';

class SpellSlotRepository {
  static final SpellSlotRepository instance = SpellSlotRepository._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  SpellSlotRepository._init();

  Future<Database> get database async => await _characterRepository.database;

  Future<void> createSpellSlotTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS spell_slots(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        characterId INTEGER,
        level INTEGER,
        total INTEGER,
        used INTEGER,
        FOREIGN KEY (characterId) REFERENCES characters (id)
      )
    ''');
  }

  Future<int> createSpellSlot(SpellSlot spellSlot) async {
    final db = await database;
    return await db.insert('spell_slots', spellSlot.toMap());
  }

  Future<List<SpellSlot>> readSpellSlotsForCharacter(int characterId) async {
    final db = await database;
    final maps = await db.query(
      'spell_slots',
      where: 'characterId = ?',
      whereArgs: [characterId],
    );
    return List.generate(maps.length, (i) => SpellSlot.fromMap(maps[i]));
  }

  Future<void> clearDB() async {
    final db = await database;
    await db.execute('DELETE FROM spell_slots');
    await db.execute('DROP TABLE spell_slots');
  }

  Future<SpellSlot> updateSpellSlot(SpellSlot spellSlot) async {
    final db = await database;
    final existing = await db.query(
      'spell_slots',
      where: 'characterId = ? AND level = ?',
      whereArgs: [spellSlot.characterId, spellSlot.level],
    );

    if (existing.isEmpty) {
      final id = await db.insert('spell_slots', spellSlot.toMap());
      return spellSlot.copyWith(id: id);
    } else {
      await db.update(
        'spell_slots',
        spellSlot.toMap(),
        where: 'characterId = ? AND level = ?',
        whereArgs: [spellSlot.characterId, spellSlot.level],
      );
      return spellSlot;
    }
  }

  Future<SpellSlot> readSpellSlot(int spellSlotId) async {
    final db = await database;
    final spellSlot = await db.query(
      'spell_slots',
      where: 'id = ?',
      whereArgs: [spellSlotId],
    );
    return SpellSlot.fromMap(spellSlot[0]);
  }

  Future<int> deleteSpellSlot(int id) async {
    final db = await database;
    return await db.delete(
      'spell_slots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSpellSlotsForCharacter(int characterId) async {
    final db = await database;
    await db.delete(
      'spell_slots',
      where: 'characterId = ?',
      whereArgs: [characterId],
    );
  }
}
