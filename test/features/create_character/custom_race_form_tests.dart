import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/custom_race_form.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/providers/custom_race_provider.dart';

class TestCustomRacesNotifier extends CustomRacesNotifier {
  Race? addedRace;

  @override
  Future<void> addCustomRace(Race race) async {
    addedRace = race;
  }
}

void main() {
  late ProviderContainer container;
  late TestCustomRacesNotifier testNotifier;

  Future<void> pumpCustomRaceForm(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: CustomRaceForm(),
        ),
      ),
    );
  }

  setUp(() {
    testNotifier = TestCustomRacesNotifier();
    container = ProviderContainer(
      overrides: [
        customRacesProvider.overrideWith((ref) => testNotifier),
      ],
    );
  });

  testWidgets('CustomRaceForm displays all required fields',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    expect(find.text('Create Custom Race'), findsOneWidget);
    expect(find.text('Basic Information'), findsOneWidget);
    expect(find.text('Racial Traits'), findsOneWidget);
    expect(find.text('Special Abilities'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Race Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Description'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Speed'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Size'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Languages'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Age'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Alignment'), findsOneWidget);
  });

  testWidgets('Form shows validation errors when submitted empty',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    await tester.tap(find.text('Create Race'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a race name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('Form successfully creates custom race with valid input',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Race Name'), 'Test Race');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');

    await tester.tap(find.text('Create Race'));
    await tester.pumpAndSettle();

    expect(testNotifier.addedRace?.name, equals('Test Race'));
    expect(testNotifier.addedRace?.description, equals('Test Description'));
    expect(testNotifier.addedRace?.speed, equals('30 feet')); // Default value
    expect(testNotifier.addedRace?.size, equals('Medium')); // Default value
    expect(
        testNotifier.addedRace?.languages, equals('Common')); // Default value
  });

  testWidgets('Form has correct default values', (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    final speedField = find.widgetWithText(TextFormField, 'Speed');
    final sizeField = find.widgetWithText(TextFormField, 'Size');
    final languagesField = find.widgetWithText(TextFormField, 'Languages');
    final ageField = find.widgetWithText(TextFormField, 'Age');
    final alignmentField = find.widgetWithText(TextFormField, 'Alignment');

    expect((tester.widget(speedField) as TextFormField).controller?.text,
        '30 feet');
    expect(
        (tester.widget(sizeField) as TextFormField).controller?.text, 'Medium');
    expect((tester.widget(languagesField) as TextFormField).controller?.text,
        'Common');
    expect((tester.widget(ageField) as TextFormField).controller?.text, '20');
    expect((tester.widget(alignmentField) as TextFormField).controller?.text,
        'Neutral');
  });

  testWidgets('Can add and remove special abilities',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    // Add ability
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ability Name'), 'Test Ability');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ability Description'),
        'Test Ability Description');
    await tester.tap(find.text('Add Ability'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ability'), findsOneWidget);
    expect(find.text('Test Ability Description'), findsOneWidget);

    // Remove ability
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Test Ability'), findsNothing);
    expect(find.text('Test Ability Description'), findsNothing);
  });

  testWidgets('Empty ability fields do not create new ability',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    await tester.tap(find.text('Add Ability'));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Form navigates back after successful submission',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const CustomRaceForm(),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Race Name'), 'Test Race');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');

    await tester.tap(find.text('Create Race'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomRaceForm), findsNothing);
  });

  testWidgets('Special abilities are included in created race',
      (WidgetTester tester) async {
    await pumpCustomRaceForm(tester);

    // Fill in required fields
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Race Name'), 'Test Race');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');

    // Add an ability
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ability Name'), 'Test Ability');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ability Description'),
        'Test Ability Description');
    await tester.tap(find.text('Add Ability'));
    await tester.pumpAndSettle();

    // Submit the form
    await tester.tap(find.text('Create Race'));
    await tester.pumpAndSettle();

    expect(testNotifier.addedRace?.abilities.length, equals(1));
    expect(
        testNotifier.addedRace?.abilities.first.name, equals('Test Ability'));
    expect(testNotifier.addedRace?.abilities.first.description,
        equals('Test Ability Description'));
  });
}
