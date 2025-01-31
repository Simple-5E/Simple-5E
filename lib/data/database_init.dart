import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:simple5e/data/class_repository.dart';
import 'package:simple5e/data/race_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simple5e/data/character_repository.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/data/spell_slot_repository.dart';
import 'package:simple5e/models/spell.dart';

class DatabaseInitializer {
  static final DatabaseInitializer instance = DatabaseInitializer._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;
  final SpellRepository _spellRepository = SpellRepository.instance;
  final SpellSlotRepository _spellSlotRepository = SpellSlotRepository.instance;
  final ClassRepository _classRepository = ClassRepository.instance;
  final RaceRepository _raceRepository = RaceRepository.instance;

  DatabaseInitializer._init();

  Future<void> initializeDatabase() async {
    final db = await _characterRepository.database;
    await _createTables(db);
    await _cleanDefaultData(db);
    await _insertSpellsFromJson();
  }

  Future<void> _createTables(Database db) async {
    await _characterRepository.createDB(db, 1);
    await _spellRepository.createSpellTables(db);
    await _spellSlotRepository.createSpellSlotTable(db);
    await _classRepository.createTables(db);
    await _raceRepository.createTables(db);
  }

  Future<void> _cleanDefaultData(Database db) async {
    await _spellRepository.deleteDefaultSpells();
  }

  Future<void> _insertSpellsFromJson() async {
    final String spellsJson = await rootBundle.loadString('assets/spells.json');
    final List<dynamic> spellsData = json.decode(spellsJson);

    for (var spellData in spellsData) {
      final spell = Spell.fromJson(spellData);
      await _spellRepository.createSpell(spell);
    }
  }
}
