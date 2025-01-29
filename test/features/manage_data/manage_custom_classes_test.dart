import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/manage_data/manage_custom_classes_page.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

class MockCustomClassNotifier extends CustomClassesNotifier {
  MockCustomClassNotifier(List<CharacterClass>? classes) : super() {
    state = AsyncValue.data(classes ?? []);
  }

  @override
  Future<void> deleteCustomClass(String className) async {
    state = AsyncValue.data([]);
    return Future.value();
  }

  @override
  Future<void> addCustomClass(CharacterClass characterClass) async {
    return Future.value();
  }

  @override
  Future<void> updateCustomClass(CharacterClass characterClass) async {
    return Future.value();
  }
}

class MockLoadingCustomClassNotifier extends CustomClassesNotifier {
  MockLoadingCustomClassNotifier() : super() {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> deleteCustomClass(String className) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> addCustomClass(CharacterClass characterClass) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> updateCustomClass(CharacterClass characterClass) async {
    state = const AsyncValue.loading();
  }
}

class MockErrorCustomClassNotifier extends CustomClassesNotifier {
  MockErrorCustomClassNotifier() : super() {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> deleteCustomClass(String className) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> addCustomClass(CharacterClass characterClass) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> updateCustomClass(CharacterClass characterClass) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }
}

void main() {
  final testClass = CharacterClass(
    name: 'Test Class',
    description: 'A test class description',
    hitDie: 'd8',
    proficiencies: ['Test Proficiency'],
    spellcasting: 'None',
  );

  Widget createWidgetUnderTest({List<CharacterClass>? classes}) {
    return ProviderScope(
      overrides: [
        customClassesProvider
            .overrideWith((ref) => MockCustomClassNotifier(classes)),
      ],
      child: const MaterialApp(
        home: ManageCustomClassesPage(),
      ),
    );
  }

  group('ManageCustomClassesPage', () {
    testWidgets('shows empty state when no custom classes exist',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No custom classes found.'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays custom class list when classes exist',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        classes: [testClass],
      ));

      expect(find.text('Test Class'), findsOneWidget);
      expect(find.text('A test class description'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customClassesProvider.overrideWith(
              (ref) => MockLoadingCustomClassNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: ManageCustomClassesPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error occurs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customClassesProvider
                .overrideWith((ref) => MockErrorCustomClassNotifier()),
          ],
          child: const MaterialApp(
            home: ManageCustomClassesPage(),
          ),
        ),
      );

      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows delete dialog when delete button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        classes: [testClass],
      ));

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Class'), findsOneWidget);
      expect(find.text('Are you sure you want to delete Test Class?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('navigates to class details when class is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        classes: [testClass],
      ));

      await tester.tap(find.text('Test Class'));
      await tester.pumpAndSettle();

      // Verify navigation to ClassDetails
      expect(find.byType(ManageCustomClassesPage), findsNothing);
    });

    testWidgets('navigates to custom class form when add button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify navigation to CustomClassForm
      expect(find.byType(ManageCustomClassesPage), findsNothing);
    });
  });
}
