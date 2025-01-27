import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/models/spell.dart';

final spellsProvider =
    StateNotifierProvider<SpellsNotifier, AsyncValue<List<Spell>>>((ref) {
  return SpellsNotifier();
});

class SpellsNotifier extends StateNotifier<AsyncValue<List<Spell>>> {
  SpellsNotifier() : super(const AsyncValue.loading()) {
    _loadSpells();
  }

  Future<void> _loadSpells() async {
    state = const AsyncValue.loading();
    try {
      final spells = await SpellRepository.instance.readAllSpells();
      state = AsyncValue.data(spells);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSpell(Spell spell) async {
    try {
      await SpellRepository.instance.createSpell(spell);
      _loadSpells(); // Reload the list after adding
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpell(Spell spell) async {
    try {
      await SpellRepository.instance.updateSpell(spell);
      _loadSpells(); // Reload the list after updating
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteSpell(String name) async {
    try {
      await SpellRepository.instance.deleteSpell(name);
      _loadSpells(); // Reload the list after deleting
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Spell?> getSpell(String name) async {
    try {
      return await SpellRepository.instance.readSpell(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Optional: Provider for a single spell
final spellProvider = FutureProvider.family<Spell?, String>((ref, name) async {
  return SpellRepository.instance.readSpell(name);
});

final userDefinedSpellsProvider =
    StateNotifierProvider<UserDefinedSpellsNotifier, AsyncValue<List<Spell>>>(
        (ref) {
  return UserDefinedSpellsNotifier();
});

class UserDefinedSpellsNotifier extends StateNotifier<AsyncValue<List<Spell>>> {
  UserDefinedSpellsNotifier() : super(const AsyncValue.loading()) {
    _loadUserDefinedSpells();
  }

  Future<void> _loadUserDefinedSpells() async {
    state = const AsyncValue.loading();
    try {
      final spells = await SpellRepository.instance.readAllUserDefinedSpells();
      state = AsyncValue.data(spells);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSpell(Spell spell) async {
    try {
      await SpellRepository.instance.createSpell(spell);
      _loadUserDefinedSpells(); // Reload the list after adding
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpell(Spell spell) async {
    await SpellRepository.instance.updateSpell(spell);
    _loadUserDefinedSpells();
  }

  Future<void> deleteSpell(String name) async {
    await SpellRepository.instance.deleteSpell(name);
    _loadUserDefinedSpells();
  }
}
