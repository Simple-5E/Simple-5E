import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple5e/features/create_character/class_details.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/widgets/class_image_widget.dart';

void main() {
  final mockCharacterClass = CharacterClass(
    name: 'Fighter',
    description:
        'A master of martial combat, skilled with a variety of weapons and armor',
    hitDie: 'd10',
    proficiencies: [
      'All armor',
      'Shields',
      'Simple weapons',
      'Martial weapons'
    ],
    spellcasting: 'None',
  );

  Future<void> pumpClassDetails(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClassDetails(
            characterClass: mockCharacterClass,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('ClassDetails displays class name in app bar',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.text('Fighter'), findsOneWidget);
  });

  testWidgets('ClassDetails displays class description',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(
        find.text(
            'A master of martial combat, skilled with a variety of weapons and armor'),
        findsOneWidget);
  });

  testWidgets('ClassDetails displays hit die information',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.text('Hit Die'), findsOneWidget);
    expect(find.text('d10'), findsOneWidget);
  });

  testWidgets('ClassDetails displays proficiencies',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.text('Proficiencies'), findsOneWidget);
    expect(find.text('All armor, Shields, Simple weapons, Martial weapons'),
        findsOneWidget);
  });

  testWidgets('ClassDetails displays spellcasting information',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.text('Spellcasting'), findsOneWidget);
    expect(find.text('None'), findsOneWidget);
  });

  testWidgets('ClassDetails shows class image widget',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.byType(ClassImageWidget), findsOneWidget);
  });

  testWidgets('ClassDetails has proper layout structure',
      (WidgetTester tester) async {
    await pumpClassDetails(tester);

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.byType(SliverToBoxAdapter), findsOneWidget);
  });
}
