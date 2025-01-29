import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/race_details.dart';
import 'package:simple5e/models/race.dart';

void main() {
  final testRace = Race(
      name: 'Test Race',
      description: 'Test Description',
      abilityScoreIncrease: '+2 Strength',
      speed: '30 feet',
      size: 'Medium',
      languages: 'Common',
      abilities: [
        RaceAbility(
          name: 'Test Ability',
          description: 'Test Ability Description',
        ),
      ],
      age: '30',
      alignment: 'Neutral');

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: RaceDetails(race: testRace),
        ),
      ),
    );
  }

  group('RaceDetails', () {
    testWidgets('displays race name in app bar', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Race'), findsOneWidget);
    });

    testWidgets('displays race description', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('displays quick stats correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Quick Stats'), findsOneWidget);
      expect(find.text('Ability Bonus'), findsOneWidget);
      expect(find.text('+2 Strength'), findsOneWidget);
      expect(find.text('Speed'), findsOneWidget);
      expect(find.text('30 feet'), findsOneWidget);
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Languages'), findsOneWidget);
      expect(find.text('Common'), findsOneWidget);
    });

    testWidgets('displays race abilities', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Special Abilities'), findsOneWidget);
      expect(find.text('Test Ability'), findsOneWidget);
      expect(find.text('Test Ability Description'), findsOneWidget);
    });

    testWidgets('image index changes when navigation arrows are tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the forward arrow and tap it
      final forwardArrow = find.byIcon(Icons.arrow_forward_ios);
      await tester.tap(forwardArrow);
      await tester.pump();

      // Verify the image index changed by checking the provider state
      final context = tester.element(find.byType(RaceDetails));
      final container = ProviderScope.containerOf(context);
      expect(container.read(raceImageIndexProvider), 2);

      // Tap the back arrow
      final backArrow = find.byIcon(Icons.arrow_back_ios);
      await tester.tap(backArrow);
      await tester.pump();

      // Verify the image index changed back
      expect(container.read(raceImageIndexProvider), 1);
    });

    testWidgets('scrolls properly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify initial scroll position
      final scrollableFinder = find.byType(CustomScrollView);
      final scrollable = tester.widget<CustomScrollView>(scrollableFinder);
      expect(scrollable, isNotNull);

      // Perform scroll
      await tester.dragFrom(const Offset(0, 300), const Offset(0, -300));
      await tester.pump();

      // Verify content is still visible after scrolling
      expect(find.text('Quick Stats'), findsOneWidget);
    });
  });
}
