import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/spellbook/spell_selection_page.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:simple5e/providers/providers.dart';

import 'spell_selection_page_test.mocks.dart';

@GenerateMocks([SpellRepository])
void main() {
  late ProviderContainer container;
  late MockSpellRepository mockSpellRepository;

  // Create mock spells for testing
  final mockSpells = [
    Spell(
      name: 'Fireball',
      level: '3rd-level',
      castingTime: '1 action',
      range: '150 feet',
      components: 'V, S, M',
      duration: 'Instantaneous',
      description: 'A bright streak flashes from your pointing finger...',
      classes: ['Wizard', 'Sorcerer'],
      additionalNotes: null,
    ),
    Spell(
      name: 'Magic Missile',
      level: '1st-level',
      castingTime: '1 action',
      range: '120 feet',
      components: 'V, S',
      duration: 'Instantaneous',
      description: 'You create three glowing darts of magical force...',
      classes: ['Wizard', 'Sorcerer'],
      additionalNotes: null,
    ),
    Spell(
      name: 'Light',
      level: 'Cantrip',
      castingTime: '1 action',
      range: 'Touch',
      components: 'V, M',
      duration: '1 hour',
      description: 'You touch one object...',
      classes: ['Cleric', 'Wizard'],
      additionalNotes: null,
    ),
  ];

  setUp(() {
    mockSpellRepository = MockSpellRepository();
    SpellRepository.instance = mockSpellRepository;

    when(mockSpellRepository.readAllSpells())
        .thenAnswer((_) async => mockSpells);

    // Mock readSpellsForCharacter to simulate Fireball already being in spellbook
    when(mockSpellRepository.readSpellsForCharacter(any))
        .thenAnswer((_) async => [mockSpells[0]]); // returns Fireball

    container = ProviderContainer(
      overrides: [],
    );
  });

  Future<void> pumpSpellSelectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: SpellSelectionPage(characterId: 1),
        ),
      ),
    );
    // Wait for initial load
    await tester.pumpAndSettle();
  }

  testWidgets('SpellSelectionPage loads and displays spells',
      (WidgetTester tester) async {
    await pumpSpellSelectionPage(tester);

    // Verify all mock spells are displayed
    expect(find.text('Fireball'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
  });

  testWidgets('Search functionality filters spells correctly',
      (WidgetTester tester) async {
    await pumpSpellSelectionPage(tester);

    // Find search field and enter text
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'fire');
    await tester.pumpAndSettle();

    // Verify only Fireball is shown
    expect(find.text('Fireball'), findsOneWidget);
    expect(find.text('Magic Missile'), findsNothing);
    expect(find.text('Light'), findsNothing);
  });

  testWidgets('Class filter chips work correctly', (WidgetTester tester) async {
    await pumpSpellSelectionPage(tester);

    // Tap on Cleric filter
    await tester.tap(find.text('Cleric'));
    await tester.pumpAndSettle();

    // Verify only Cleric spells are shown
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Fireball'), findsNothing);
    expect(find.text('Magic Missile'), findsNothing);
  });

  testWidgets('Spell details expand when tapped', (WidgetTester tester) async {
    await pumpSpellSelectionPage(tester);

    // Initially, description should not be visible
    expect(find.text('You touch one object...').hitTestable(), findsNothing);

    // Tap the expand button for Fireball
    await tester.tap(find.byIcon(Icons.expand_more).first);
    await tester.pumpAndSettle();

    // Verify description is now visible
    expect(find.text('You touch one object...').hitTestable(), findsOneWidget);
  });

  testWidgets('Spells are sorted by level and then name',
      (WidgetTester tester) async {
    await pumpSpellSelectionPage(tester);

    // Get all spell names in order
    final spellNames = tester
        .widgetList(find.byType(ListTile))
        .map((widget) => (widget as ListTile).title as Text)
        .map((text) => text.data)
        .toList();

    // Verify order: Cantrips first, then by level, then alphabetically
    expect(spellNames, ['Light', 'Magic Missile', 'Fireball']);
  });

  group('Spell addition tests', () {
    testWidgets('Successfully adding a new spell shows success message',
        (WidgetTester tester) async {
      // Mock empty spellbook for character
      when(mockSpellRepository.readSpellsForCharacter(any))
          .thenAnswer((_) async => []);

      await pumpSpellSelectionPage(tester);

      // Try to add Magic Missile (not a duplicate)
      await tester.tap(find.descendant(
        of: find.ancestor(
          of: find.text('Magic Missile'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.add),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Magic Missile added to spellbook'), findsOneWidget);
    });

    testWidgets('Adding duplicate spell shows error message',
        (WidgetTester tester) async {
      // Mock spellbook containing Fireball
      when(mockSpellRepository.readSpellsForCharacter(any)).thenAnswer(
          (_) async => [mockSpells[0]]); // Fireball is already in spellbook

      await pumpSpellSelectionPage(tester);

      // Try to add Fireball (which is already in spellbook)
      await tester.tap(find.descendant(
        of: find.ancestor(
          of: find.text('Fireball'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.add),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Fireball is already in spellbook'), findsOneWidget);

      // Verify error styling
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(
        snackBar.backgroundColor,
        equals(Theme.of(tester.element(find.byType(MaterialApp)))
            .colorScheme
            .error),
      );
    });

    testWidgets('Verify spell add not called for duplicates',
        (WidgetTester tester) async {
      // Mock spellbook containing Fireball
      when(mockSpellRepository.readSpellsForCharacter(any)).thenAnswer(
          (_) async => [mockSpells[0]]); // Fireball is already in spellbook

      var addSpellCalled = false;

      // Override the add spell provider to track if it's called
      container = ProviderContainer(
        overrides: [
          addSpellProvider.overrideWithProvider(
              (characterId) => Provider((ref) => (Spell spell) async {
                    addSpellCalled = true;
                  })),
        ],
      );

      await pumpSpellSelectionPage(tester);

      // Try to add Fireball (which is already in spellbook)
      await tester.tap(find.descendant(
        of: find.ancestor(
          of: find.text('Fireball'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.add),
      ));
      await tester.pumpAndSettle();

      // Verify that addSpell was never called
      expect(addSpellCalled, false);
    });
  });

  tearDown(() {
    container.dispose();
  });
}
