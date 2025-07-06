import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/class_selection.dart';
import 'package:simple5e/features/create_character/custom_class_form.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

class TestCustomClassesNotifier extends CustomClassesNotifier {
  final List<CharacterClass> mockClasses;

  TestCustomClassesNotifier(this.mockClasses);

  @override
  Future<void> loadCustomClasses() async {
    state = AsyncValue.data(mockClasses);
  }
}

class LoadingCustomClassesNotifier extends CustomClassesNotifier {
  @override
  Future<void> loadCustomClasses() async {
    state = const AsyncValue.loading();
  }
}

class ErrorCustomClassesNotifier extends CustomClassesNotifier {
  @override
  Future<void> loadCustomClasses() async {
    state = AsyncValue.error('Error loading classes', StackTrace.current);
  }
}

void main() {
  late ProviderContainer container;

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

  final mockCustomClasses = [
    CharacterClass(
      name: 'Custom Fighter',
      description: 'A custom fighting class',
      hitDie: 'd10',
      proficiencies: ['Weapons', 'Armor'],
      spellcasting: 'None',
    )
  ];

  Future<void> pumpClassSelection(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ClassSelection(selectedRace: mockRace),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    container = ProviderContainer(
      overrides: [
        customClassesProvider.overrideWith(
          (ref) => TestCustomClassesNotifier(mockCustomClasses),
        ),
        currentClassPageProvider.overrideWith((ref) => 0),
      ],
    );
  });

  testWidgets('ClassSelection displays predefined classes',
      (WidgetTester tester) async {
    await pumpClassSelection(tester);

    expect(find.text('Barbarian'), findsOneWidget);
    expect(find.text('Choose Barbarian'), findsOneWidget);
  });

  testWidgets('ClassSelection shows next class', (WidgetTester tester) async {
    await pumpClassSelection(tester);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Bard'), findsOneWidget);
  });

  testWidgets('ClassSelection shows custom classes',
      (WidgetTester tester) async {
    await pumpClassSelection(tester);

    while (find.text('Custom Fighter').evaluate().isEmpty) {
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
    }

    expect(find.text('Custom Fighter'), findsOneWidget);
  });

  testWidgets('ClassSelection shows create custom class page as last page',
      (WidgetTester tester) async {
    await pumpClassSelection(tester);

    while (find.text('Create Custom Class').evaluate().isEmpty) {
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
    }

    expect(find.text('Create Your Own Class'), findsOneWidget);
    expect(
        find.text('Design a unique class with custom abilities and features'),
        findsOneWidget);
  });

  testWidgets('Page indicators update correctly', (WidgetTester tester) async {
    await pumpClassSelection(tester);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(container.read(currentClassPageProvider), 1);
  });

  testWidgets('Navigation to name selection works',
      (WidgetTester tester) async {
    await pumpClassSelection(tester);

    await tester.tap(find.text('Choose Barbarian'));
    await tester.pumpAndSettle();

    expect(find.byType(ClassSelection), findsNothing);
  });

  testWidgets('Custom class creation button shows form',
      (WidgetTester tester) async {
    await pumpClassSelection(tester);

    while (find.text('Create Custom Class').evaluate().isEmpty) {
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Create Custom Class').last);
    await tester.pumpAndSettle();

    expect(find.byType(CustomClassForm), findsOneWidget);
  });

  testWidgets('Handles error state gracefully', (WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        customClassesProvider.overrideWith(
          (ref) => ErrorCustomClassesNotifier(),
        ),
      ],
    );

    await pumpClassSelection(tester);

    expect(find.text('Error: Error loading classes'), findsOneWidget);
  });

  testWidgets('Shows loading state', (WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        customClassesProvider.overrideWith(
          (ref) => LoadingCustomClassesNotifier(),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ClassSelection(selectedRace: mockRace),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
