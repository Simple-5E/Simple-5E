import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/manage_data/manage_custom_races.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/providers/custom_race_provider.dart';

class MockCustomRaceNotifier extends CustomRacesNotifier {
  MockCustomRaceNotifier(List<Race>? races) : super() {
    state = AsyncValue.data(races ?? []);
  }

  @override
  Future<void> deleteCustomRace(String raceName) async {
    state = AsyncValue.data(
      state.value!.where((r) => r.name != raceName).toList(),
    );
  }

  @override
  Future<void> addCustomRace(Race race) async {
    return Future.value();
  }

  @override
  Future<void> updateCustomRace(Race race) async {
    return Future.value();
  }
}

class MockLoadingCustomRaceNotifier extends CustomRacesNotifier {
  MockLoadingCustomRaceNotifier() : super() {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> deleteCustomRace(String raceName) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> addCustomRace(Race race) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> updateCustomRace(Race race) async {
    state = const AsyncValue.loading();
  }
}

class MockErrorCustomRaceNotifier extends CustomRacesNotifier {
  MockErrorCustomRaceNotifier() : super() {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> deleteCustomRace(String raceName) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> addCustomRace(Race race) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> updateCustomRace(Race race) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }
}

void main() {
  final testRace = Race(
    name: 'Test Race',
    description: 'A test race description',
    size: 'Medium',
    speed: '30',
    abilityScoreIncrease: '+2 STR',
    age: 'Test age',
    alignment: 'Test alignment',
    languages: 'Common',
    abilities: [],
  );

  Widget createWidgetUnderTest({List<Race>? races}) {
    return ProviderScope(
      overrides: [
        customRacesProvider
            .overrideWith((ref) => MockCustomRaceNotifier(races)),
      ],
      child: const MaterialApp(
        home: ManageCustomRacesPage(),
      ),
    );
  }

  group('ManageCustomRacesPage', () {
    testWidgets('shows empty state when no custom races exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No custom races found.'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays custom race list when races exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(races: [testRace]));

      expect(find.text('Test Race'), findsOneWidget);
      expect(find.text('A test race description'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // Check for chips
      expect(find.text('Size: Medium'), findsOneWidget);
      expect(find.text('Speed: 30'), findsOneWidget);
      expect(find.text('+2 STR'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customRacesProvider
                .overrideWith((ref) => MockLoadingCustomRaceNotifier()),
          ],
          child: const MaterialApp(
            home: ManageCustomRacesPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error occurs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customRacesProvider
                .overrideWith((ref) => MockErrorCustomRaceNotifier()),
          ],
          child: const MaterialApp(
            home: ManageCustomRacesPage(),
          ),
        ),
      );

      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows delete dialog when delete button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(races: [testRace]));

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Race'), findsOneWidget);
      expect(find.text('Are you sure you want to delete Test Race?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('navigates to race details when race is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(races: [testRace]));

      await tester.tap(find.text('Test Race'));
      await tester.pumpAndSettle();

      // Verify navigation to RaceDetails
      expect(find.byType(ManageCustomRacesPage), findsNothing);
    });

    testWidgets('navigates to custom race form when add button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify navigation to CustomRaceForm
      expect(find.byType(ManageCustomRacesPage), findsNothing);
    });

    testWidgets('displays chips with correct information', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(races: [testRace]));

      expect(find.byType(Chip), findsNWidgets(3));
      expect(find.text('Size: Medium'), findsOneWidget);
      expect(find.text('Speed: 30'), findsOneWidget);
      expect(find.text('+2 STR'), findsOneWidget);
    });
  });
}
