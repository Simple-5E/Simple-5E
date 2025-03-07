import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple5e/features/home/home_page.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/providers/providers.dart';
import 'package:simple5e/data/character_repository.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:simple5e/data/spell_slot_repository.dart';

import 'home_test.mocks.dart';

class MockCharactersNotifier extends CharactersNotifier {
  MockCharactersNotifier(List<Character>? characters) : super() {
    state = AsyncValue.data(characters ?? []);
  }

  @override
  Future<void> updateCharacter(Character updatedCharacter) {
    return Future.value();
  }

  @override
  Future<void> updateCharacterStat<T>(
      int characterId, String statName, T newValue) {
    return Future.value();
  }
}

class MockLoadingCharactersNotifier extends CharactersNotifier {
  MockLoadingCharactersNotifier() : super() {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> updateCharacter(Character updatedCharacter) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> updateCharacterStat<T>(
      int characterId, String statName, T newValue) async {
    state = const AsyncValue.loading();
  }
}

class MockErrorCharactersNotifier extends CharactersNotifier {
  MockErrorCharactersNotifier() : super() {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> updateCharacter(Character updatedCharacter) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> updateCharacterStat<T>(
      int characterId, String statName, T newValue) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }
}

@GenerateMocks([CharacterRepository, SpellRepository, SpellSlotRepository])
void main() {
  late MockCharacterRepository mockCharacterRepository;
  late MockSpellRepository mockSpellRepository;
  late MockSpellSlotRepository mockSpellSlotRepository;

  setUp(() {
    mockCharacterRepository = MockCharacterRepository();
    mockSpellRepository = MockSpellRepository();
    mockSpellSlotRepository = MockSpellSlotRepository();

    CharacterRepository.instance = mockCharacterRepository;
    SpellRepository.instance = mockSpellRepository;
    SpellSlotRepository.instance = mockSpellSlotRepository;
  });

  final testCharacter = Character(
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
    assetUri: 'assets/races/dragonborn_1.webp',
    id: 0,
  );

  Widget createWidgetUnderTest({List<Character>? characters}) {
    return ProviderScope(
      overrides: [
        charactersProvider.overrideWith(
          (ref) => MockCharactersNotifier(characters),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('shows empty state when no characters exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No characters yet'), findsOneWidget);
      expect(find.text('Tap the + button to create your first character!'),
          findsOneWidget);
      expect(find.byIcon(Icons.person_add_rounded), findsOneWidget);
    });

    testWidgets('displays character list when characters exist',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        characters: [testCharacter],
      ));

      expect(find.text('Mock Character'), findsOneWidget);
      expect(find.text('Human Fighter'), findsOneWidget);
      expect(find.text('Level 1'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            charactersProvider
                .overrideWith((ref) => MockLoadingCharactersNotifier()),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error occurs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            charactersProvider
                .overrideWith((ref) => MockErrorCharactersNotifier()),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows delete dialog on long press', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        characters: [testCharacter],
      ));

      await tester.longPress(find.text('Mock Character'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Mock Character?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('deletes character when confirmed', (tester) async {
      when(mockCharacterRepository.deleteCharacter(any))
          .thenAnswer((_) async => 1);
      when(mockSpellSlotRepository.deleteSpellSlotsForCharacter(any))
          .thenAnswer((_) async => 1);
      when(mockSpellRepository.clearSpellsForCharacter(any))
          .thenAnswer((_) async => 1);

      await tester.pumpWidget(createWidgetUnderTest(
        characters: [testCharacter],
      ));

      await tester.longPress(find.text('Mock Character'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Use any() matcher for verification to avoid type issues
      verify(mockCharacterRepository.deleteCharacter(any)).called(1);
      verify(mockSpellSlotRepository.deleteSpellSlotsForCharacter(any)).called(1);
      verify(mockSpellRepository.clearSpellsForCharacter(any)).called(1);
    });

    testWidgets('navigates to character sheet on tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        characters: [testCharacter],
      ));

      await tester.tap(find.text('Mock Character'));
      await tester.pumpAndSettle();

      // Verify navigation to CharacterSheetPage
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('shows menu drawer when menu button is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
