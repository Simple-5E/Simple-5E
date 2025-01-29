import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:simple5e/features/home/character_sheet_page.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/providers/providers.dart';

@GenerateMocks([])
void main() {
  late ProviderContainer container;

  Future<void> pumpCharacterSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: CharacterSheetPage(characterId: 0),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    container = ProviderContainer(overrides: [
      characterProvider.overrideWith((ref, id) => AsyncValue.data(Character(
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
          ))),
      characterSpellsProvider
          .overrideWith((ref, id) => Future.value(<Spell>[])),
    ]);
  });

  testWidgets('CharacterSheetPage displays character name in AppBar',
      (WidgetTester tester) async {
    await pumpCharacterSheet(tester);

    expect(find.text('Mock Character'), findsOneWidget);
  });

  testWidgets('CharacterSheetPage displays character stats correctly',
      (WidgetTester tester) async {
    await pumpCharacterSheet(tester);

    expect(find.text('16'), findsAny);
    expect(find.text('1'), findsAny);
    expect(find.text('45'), findsAny);
  });

  testWidgets('CharacterSheetPage handles error state',
      (WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        characterProvider.overrideWith(
            (ref, id) => AsyncValue.error('Error', StackTrace.empty)),
        characterSpellsProvider
            .overrideWith((ref, id) => Future.value(<Spell>[])),
      ],
    );

    await pumpCharacterSheet(tester);
    expect(find.text('Error loading character: Error'), findsOneWidget);
  });

  testWidgets('Navigation buttons are present and working',
      (WidgetTester tester) async {
    await pumpCharacterSheet(tester);

    await tester.pump();

    expect(find.text('Spell Book'), findsOneWidget);
    expect(find.text('Full Stats'), findsOneWidget);
  });

  testWidgets('Tapping stat card shows edit dialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 2048);
    tester.view.devicePixelRatio = 1.0;

    await pumpCharacterSheet(tester);

    final strengthCard = find.ancestor(
      of: find.text('Strength'),
      matching: find.byType(Card),
    );

    expect(strengthCard, findsOneWidget);
    await tester.tap(strengthCard);
    await tester.pumpAndSettle();

    expect(find.text('Edit Strength'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);

    addTearDown(() {
      tester.view.reset();
    });
  });
}
