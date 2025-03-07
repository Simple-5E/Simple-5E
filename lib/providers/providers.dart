import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/character_repository.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/data/spell_slot_repository.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/models/spell_slot.dart';

// Character providers
final charactersProvider =
    StateNotifierProvider<CharactersNotifier, AsyncValue<List<Character>>>(
        (ref) {
  return CharactersNotifier();
});

class CharactersNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  final CharacterRepository _repository = CharacterRepository.instance;
  
  CharactersNotifier() : super(const AsyncValue.loading()) {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    state = const AsyncValue.loading();
    try {
      final characters = await _repository.readAllCharacters();
      state = AsyncValue.data(characters);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCharacter(Character updatedCharacter) async {
    try {
      await _repository.updateCharacter(updatedCharacter);
      loadCharacters();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCharacterStat<T>(
      int characterId, String statName, T newValue) async {
    try {
      await _repository.updateCharacterStat<T>(characterId, statName, newValue);
      loadCharacters();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> deleteCharacter(int id) async {
    try {
      await _repository.deleteCharacter(id);
      loadCharacters();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final characterProvider =
    Provider.family<AsyncValue<Character>, int>((ref, characterId) {
  final charactersAsync = ref.watch(charactersProvider);
  return charactersAsync.when(
    data: (characters) {
      try {
        final character = characters.firstWhere((c) => c.id == characterId);
        return AsyncValue.data(character);
      } catch (e) {
        return AsyncValue.error(
            'Character not found: $characterId', StackTrace.current);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Spell providers
final characterSpellsProvider =
    FutureProvider.family<List<Spell>, int>((ref, characterId) async {
  try {
    final spellRepository = SpellRepository.instance;
    return await spellRepository.readSpellsForCharacter(characterId);
  } catch (e) {
    throw Exception('Failed to load spells: $e');
  }
});

final addSpellProvider =
    Provider.family<Future<void> Function(Spell), int>((ref, characterId) {
  return (Spell spell) async {
    try {
      final spellRepository = SpellRepository.instance;
      await spellRepository.addSpellToCharacter(characterId, spell.name);
      ref.invalidate(characterSpellsProvider(characterId));
    } catch (e) {
      throw Exception('Failed to add spell: $e');
    }
  };
});

final removeSpellProvider =
    Provider.family<Future<void> Function(String), int>((ref, characterId) {
  return (String spellName) async {
    try {
      final spellRepository = SpellRepository.instance;
      await spellRepository.removeSpellFromCharacter(characterId, spellName);
      ref.invalidate(characterSpellsProvider(characterId));
    } catch (e) {
      throw Exception('Failed to remove spell: $e');
    }
  };
});

// Spell slot providers
final characterSpellSlotsProvider =
    FutureProvider.family<List<SpellSlot>, int>((ref, characterId) async {
  try {
    return SpellSlotRepository.instance.readSpellSlotsForCharacter(characterId);
  } catch (e) {
    throw Exception('Failed to load spell slots: $e');
  }
});

final characterSpellSlotProvider =
    FutureProvider.family<SpellSlot, int>((ref, spellSlotId) async {
  try {
    return await SpellSlotRepository.instance.readSpellSlot(spellSlotId);
  } catch (e) {
    throw Exception('Failed to load spell slot: $e');
  }
});

final updateSpellSlotProvider =
    Provider.family<Future<SpellSlot> Function(SpellSlot), int>(
        (ref, characterId) {
  return (SpellSlot spellSlot) async {
    try {
      final updatedSlot = 
          await SpellSlotRepository.instance.updateSpellSlot(spellSlot);
      ref.invalidate(characterSpellSlotsProvider(characterId));
      return updatedSlot;
    } catch (e) {
      throw Exception('Failed to update spell slot: $e');
    }
  };
});

// Character creation providers
class CharacterCreationState {
  final String name;
  final String race;
  final String characterClass;

  CharacterCreationState({
    this.name = '',
    this.race = '',
    this.characterClass = '',
  });

  CharacterCreationState copyWith({
    String? name,
    String? race,
    String? characterClass,
  }) {
    return CharacterCreationState(
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
    );
  }
}

class CharacterCreationNotifier extends StateNotifier<CharacterCreationState> {
  CharacterCreationNotifier() : super(CharacterCreationState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateRace(String race) {
    state = state.copyWith(race: race);
  }

  void updateCharacterClass(String characterClass) {
    state = state.copyWith(characterClass: characterClass);
  }
  
  void reset() {
    state = CharacterCreationState();
  }
}

final characterCreationProvider =
    StateNotifierProvider<CharacterCreationNotifier, CharacterCreationState>(
        (ref) {
  return CharacterCreationNotifier();
});
