import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/character_repository.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/data/spell_slot_repository.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/models/spell_slot.dart';

final charactersProvider =
    StateNotifierProvider<CharactersNotifier, AsyncValue<List<Character>>>(
        (ref) {
  return CharactersNotifier();
});

class CharactersNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  CharactersNotifier() : super(const AsyncValue.loading()) {
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    state = const AsyncValue.loading();
    try {
      final characters = await CharacterRepository.instance.readAllCharacters();
      state = AsyncValue.data(characters);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCharacter(Character updatedCharacter) async {
    await CharacterRepository.instance.updateCharacter(updatedCharacter);
    _loadCharacters();
  }

  Future<void> updateCharacterStat<T>(
      int characterId, String statName, T newValue) async {
    await CharacterRepository.instance
        .updateCharacterStat<T>(characterId, statName, newValue);
    _loadCharacters();
  }
}

final characterProvider =
    Provider.family<AsyncValue<Character>, int>((ref, characterId) {
  final charactersAsync = ref.watch(charactersProvider);
  return charactersAsync.when(
    data: (characters) {
      final character = characters.firstWhere((c) => c.id == characterId);
      return AsyncValue.data(character);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final characterSpellsProvider =
    FutureProvider.family<List<Spell>, int>((ref, characterId) async {
  final spellRepository = SpellRepository.instance;
  return await spellRepository.readSpellsForCharacter(characterId);
});

final characterSpellSlotsProvider =
    FutureProvider.family<List<SpellSlot>, int>((ref, characterId) async {
  return SpellSlotRepository.instance.readSpellSlotsForCharacter(characterId);
});

final characterSpellSlotProvider =
    FutureProvider.family<SpellSlot, int>((ref, spellSlotId) async {
  final spellSlots =
      await SpellSlotRepository.instance.readSpellSlot(spellSlotId);
  return spellSlots;
});

final characterSpellSlotUpdateProvider =
    FutureProvider.family<SpellSlot, SpellSlot>((ref, spellSlot) async {
  return await SpellSlotRepository.instance.updateSpellSlot(spellSlot);
});

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
}

final characterCreationProvider =
    StateNotifierProvider<CharacterCreationNotifier, CharacterCreationState>(
        (ref) {
  return CharacterCreationNotifier();
});

final addSpellProvider =
    Provider.family<Future<void> Function(Spell), int>((ref, characterId) {
  return (Spell spell) async {
    final spellRepository = SpellRepository.instance;
    await spellRepository.addSpellToCharacter(characterId, spell.name);
    var _ = ref.refresh(characterSpellsProvider(characterId));
  };
});
