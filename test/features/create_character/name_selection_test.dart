import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:simple5e/features/create_character/name_selection.dart';
import 'package:simple5e/features/home/home_page.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/data/character_repository.dart';

@GenerateMocks([CharacterRepository])
import 'name_selection_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockCharacterRepository mockRepository;

  void setScreenSize(WidgetTester tester,
      {double width = 1080, double height = 1920}) {
    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(width * dpi, height * dpi);
    tester.view.devicePixelRatio = dpi;
  }

  final mockRace = Race(
    name: 'Human',
    description: 'Versatile and adaptable',
    speed: '30',
    size: 'Medium',
    abilityScoreIncrease: '',
    age: '',
    alignment: '',
    languages: '',
    abilities: [],
  );

  final mockClass = CharacterClass(
    name: 'Fighter',
    description: 'A martial warrior',
    hitDie: 'd10',
    proficiencies: ['Light armor', 'Medium armor', 'Shields'],
    spellcasting: 'None',
  );

  setUp(() {
    mockRepository = MockCharacterRepository();
    container = ProviderContainer();
    CharacterRepository.instance = mockRepository;

    when(mockRepository.getNextCharacterId()).thenAnswer((_) async => 1);
    when(mockRepository.createCharacter(any)).thenAnswer((_) async => 1);
    when(mockRepository.readAllCharacters()).thenAnswer((_) async => []);
  });

  Future<void> pumpNameSelection(WidgetTester tester) async {
    setScreenSize(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: NameSelection(
            selectedRace: mockRace,
            selectedClass: mockClass,
          ),
        ),
      ),
    );
  }

  testWidgets('NameSelection displays race and class information',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    expect(find.text('Selected Race: Human'), findsOneWidget);
    expect(find.text('Selected Class: Fighter'), findsOneWidget);
  });

  testWidgets('NameSelection shows name suggestions for selected race',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    expect(find.text('Popular Human Names:'), findsOneWidget);
    expect(find.byType(ActionChip), findsWidgets);
  });

  testWidgets('Name suggestions can be selected', (WidgetTester tester) async {
    await pumpNameSelection(tester);

    final firstSuggestion = find.text('Arthur Pendragon');
    await tester.tap(firstSuggestion);
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text.isEmpty, isFalse);
  });

  testWidgets('Continue button is disabled for invalid names',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    final button = find.byType(ElevatedButton);
    expect(tester.widget<ElevatedButton>(button).enabled, isFalse);
  });

  testWidgets('Continue button is enabled for valid names',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    final button = find.byType(ElevatedButton);
    expect(tester.widget<ElevatedButton>(button).enabled, isTrue);
  });

  testWidgets('Navigates to HomePage after successful save',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Shows error message on save failure',
      (WidgetTester tester) async {
    when(mockRepository.createCharacter(any))
        .thenThrow(Exception('Save failed'));

    await pumpNameSelection(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Failed to create character. Please try again.'),
        findsOneWidget);
  });

  testWidgets('Initial armor class is calculated correctly',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    final Character capturedCharacter =
        verify(mockRepository.createCharacter(captureAny)).captured.single;
    expect(capturedCharacter.armorClass,
        14); // Fighter with medium armor proficiency
  });

  testWidgets('Name field uses word capitalization',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    final textField = find.byType(TextField);
    expect((tester.widget(textField) as TextField).textCapitalization,
        equals(TextCapitalization.words));
  });

  testWidgets('Validates minimum name length', (WidgetTester tester) async {
    await pumpNameSelection(tester);

    // Test with single character
    await tester.enterText(find.byType(TextField), 'A');
    await tester.pump();

    final button = find.byType(ElevatedButton);
    expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

    // Test with valid length
    await tester.enterText(find.byType(TextField), 'Ab');
    await tester.pump();

    expect(tester.widget<ElevatedButton>(button).enabled, isTrue);
  });

  testWidgets('Creates character with correct initial values',
      (WidgetTester tester) async {
    await pumpNameSelection(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final Character capturedCharacter =
        verify(mockRepository.createCharacter(captureAny)).captured.single;

    expect(capturedCharacter.name, equals('Test Character'));
    expect(capturedCharacter.race, equals('Human'));
    expect(capturedCharacter.characterClass, equals('Fighter'));
    expect(capturedCharacter.level, equals(1));
    expect(capturedCharacter.speed, equals(30));
    expect(capturedCharacter.healthPoints, equals(10));
    expect(capturedCharacter.proficiencyBonus, equals(2));
  });
}
