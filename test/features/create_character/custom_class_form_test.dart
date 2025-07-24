import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/custom_class_form.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

class TestCustomClassesNotifier extends CustomClassesNotifier {
  CharacterClass? addedClass;

  @override
  Future<void> addCustomClass(CharacterClass characterClass) async {
    addedClass = characterClass;
  }
}

void main() {
  late ProviderContainer container;
  late TestCustomClassesNotifier testNotifier;

  Future<void> pumpCustomClassForm(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: CustomClassForm()),
        ),
      ),
    );
  }

  setUp(() {
    testNotifier = TestCustomClassesNotifier();
    container = ProviderContainer(
      overrides: [
        customClassesProvider.overrideWith((ref) => testNotifier),
      ],
    );
  });

  testWidgets('CustomClassForm displays all required fields',
      (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    expect(find.text('Create Custom Class'), findsOneWidget);
    expect(find.text('Basic Information'), findsOneWidget);
    expect(find.text('Class Features'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Class Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Description'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Hit Die'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Spellcasting'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Proficiencies'), findsOneWidget);
  });

  testWidgets('Form shows validation errors when submitted empty',
      (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    await tester.tap(find.text('Create Class'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a class name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('Form successfully creates custom class with valid input',
      (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Class Name'), 'Test Class');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Proficiencies'), 'Weapons, Armor');

    await tester.tap(find.text('Create Class'));
    await tester.pumpAndSettle();

    expect(testNotifier.addedClass?.name, equals('Test Class'));
    expect(testNotifier.addedClass?.description, equals('Test Description'));
    expect(
        testNotifier.addedClass?.proficiencies, equals(['Weapons', 'Armor']));
    expect(testNotifier.addedClass?.hitDie, equals('d8')); // Default value
    expect(
        testNotifier.addedClass?.spellcasting, equals('None')); // Default value
  });

  testWidgets('Form has correct default values', (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    final hitDieField = find.widgetWithText(TextFormField, 'Hit Die');
    final spellcastingField =
        find.widgetWithText(TextFormField, 'Spellcasting');

    expect(
        (tester.widget(hitDieField) as TextFormField).controller?.text, 'd8');
    expect((tester.widget(spellcastingField) as TextFormField).controller?.text,
        'None');
  });

  testWidgets('CustomClassForm has proper layout and styling',
      (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    expect(
        find.byType(Card), findsNWidgets(2)); // Basic Info and Class Features
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Form handles proficiencies list correctly',
      (WidgetTester tester) async {
    await pumpCustomClassForm(tester);

    const proficiencies =
        'Swords,  Bows,Shields  '; // Intentionally messy spacing
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Class Name'), 'Test Class');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Proficiencies'), proficiencies);

    await tester.tap(find.text('Create Class'));
    await tester.pumpAndSettle();

    expect(testNotifier.addedClass?.proficiencies,
        equals(['Swords', 'Bows', 'Shields']));
  });

  testWidgets('Form navigates back after successful submission',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const CustomClassForm(),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Class Name'), 'Test Class');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test Description');

    await tester.tap(find.text('Create Class'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomClassForm), findsNothing);
  });
}
