import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:titan/data/character_repository.dart';
import 'package:titan/data/spell_repository.dart';
import 'package:titan/data/spell_slot_repository.dart';
import 'package:titan/models/character.dart';
import 'package:titan/models/spell.dart';
import 'package:titan/models/spell_slot.dart';

class DatabaseInitializer {
  static final DatabaseInitializer instance = DatabaseInitializer._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;
  final SpellRepository _spellRepository = SpellRepository.instance;
  final SpellSlotRepository _spellSlotRepository = SpellSlotRepository.instance;

  DatabaseInitializer._init();

  Future<void> initializeDatabase() async {
    final db = await _characterRepository.database;
    await _createTables(db);
    await _insertSpellsFromJson();
    // await _insertMockDataIfNeeded();
  }

  Future<void> _createTables(Database db) async {
    await _characterRepository.createDB(db, 1);
    await _spellRepository.createSpellTables(db);
    await _spellSlotRepository.createSpellSlotTable(db);
  }

  Future<void> _insertSpellsFromJson() async {
    final String spellsJson = await rootBundle.loadString('assets/spells.json');
    final List<dynamic> spellsData = json.decode(spellsJson);

    for (var spellData in spellsData) {
      final spell = Spell.fromJson(spellData);
      await _spellRepository.createSpell(spell);
    }
  }

  Future<void> _insertMockDataIfNeeded() async {
    await _insertMockCharactersIfNeeded();
    await _addMockSpellsIfNeeded(0);
    await _insertMockSpellSlotsIfNeeded();
  }

  Future<void> _insertMockCharactersIfNeeded() async {
    final characters = await _characterRepository.readAllCharacters();
    if (characters.isEmpty) {
      final mockCharacter = Character(
        level: 1,
        name: 'Mock Character',
        race: 'Human',
        characterClass: 'Fighter',
        armorClass: 16,
        initiative: 2,
        speed: 30,
        healthPoints: 45,
        temporaryPoints: 0,
        strength: 16,
        dexterity: 14,
        constitution: 15,
        intelligence: 10,
        wisdom: 12,
        charisma: 8,
        hitDice: '1d10',
        deathSaves: 0,
        dexSave: 2,
        strSave: 3,
        conSave: 2,
        intSave: 0,
        deception: 0,
        wisSave: 1,
        chaSave: -1,
        proficiencyBonus: 2,
        inspiration: 0,
        acrobatics: 2,
        sleightOfHand: 2,
        stealth: 2,
        animalHandling: 1,
        insight: 1,
        medicine: 1,
        perception: 1,
        survival: 1,
        athletics: 3,
        intimidation: -1,
        performance: -1,
        persuasion: -1,
        arcana: 0,
        history: 0,
        investigation: 0,
        nature: 0,
        religion: 0,
        assetUri: 'assets/green_warlock.webp',
        id: 0,
      );
      await _characterRepository.createCharacter(mockCharacter);
    }
  }

  Future<void> _addMockSpellsIfNeeded(int characterId) async {
    final spells = await _spellRepository.readSpellsForCharacter(characterId);
    if (spells.isEmpty) {
      final allSpells = await _spellRepository.readAllSpells();
      if (allSpells.isNotEmpty) {
        await _spellRepository.addSpellToCharacter(
            characterId, allSpells[0].name);
      }
    }
  }

  Future<void> _insertMockSpellSlotsIfNeeded() async {
    final characters = await _characterRepository.readAllCharacters();
    if (characters.isNotEmpty) {
      final spellSlots = await _spellSlotRepository
          .readSpellSlotsForCharacter(characters[0].id!);
      if (spellSlots.isEmpty) {
        for (int level = 1; level <= 9; level++) {
          await _spellSlotRepository.createSpellSlot(
            SpellSlot(
              characterId: characters[0].id!,
              level: level,
              total: level == 1 ? 4 : (level == 2 ? 3 : 2),
              used: 0,
              id: level,
            ),
          );
        }
      }
    }
  }
}
