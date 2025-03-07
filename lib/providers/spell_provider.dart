import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/models/spell.dart';

final spellsProvider =
    StateNotifierProvider<SpellsNotifier, AsyncValue<List<Spell>>>((ref) {
  return SpellsNotifier();
});

class SpellsNotifier extends StateNotifier<AsyncValue<List<Spell>>> {
  final SpellRepository _repository = SpellRepository.instance;

  SpellsNotifier() : super(const AsyncValue.loading()) {
    loadSpells();
  }

  Future<void> loadSpells() async {
    state = const AsyncValue.loading();
    try {
      final spells = await _repository.readAllSpells();
      state = AsyncValue.data(spells);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSpell(Spell spell) async {
    try {
      await _repository.createSpell(spell);
      loadSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpell(Spell spell) async {
    try {
      await _repository.updateSpell(spell);
      loadSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteSpell(String name) async {
    try {
      await _repository.deleteSpell(name);
      loadSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Spell?> getSpell(String name) async {
    try {
      return await _repository.readSpell(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Provider for a single spell
final spellProvider = FutureProvider.family<Spell?, String>((ref, name) async {
  try {
    return await SpellRepository.instance.readSpell(name);
  } catch (e) {
    throw Exception('Failed to load spell: $e');
  }
});

final userDefinedSpellsProvider =
    StateNotifierProvider<UserDefinedSpellsNotifier, AsyncValue<List<Spell>>>(
        (ref) {
  return UserDefinedSpellsNotifier();
});

class UserDefinedSpellsNotifier extends StateNotifier<AsyncValue<List<Spell>>> {
  final SpellRepository _repository = SpellRepository.instance;

  UserDefinedSpellsNotifier() : super(const AsyncValue.loading()) {
    loadUserDefinedSpells();
  }

  Future<void> loadUserDefinedSpells() async {
    state = const AsyncValue.loading();
    try {
      final spells = await _repository.readAllUserDefinedSpells();
      state = AsyncValue.data(spells);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSpell(Spell spell) async {
    try {
      await _repository.createSpell(spell);
      loadUserDefinedSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpell(Spell spell) async {
    try {
      await _repository.updateSpell(spell);
      loadUserDefinedSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteSpell(String name) async {
    try {
      await _repository.deleteSpell(name);
      loadUserDefinedSpells();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
