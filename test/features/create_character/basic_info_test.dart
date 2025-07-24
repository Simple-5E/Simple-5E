import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/basic_info.dart';
import 'package:simple5e/providers/providers.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpBasicInfo(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: BasicInfoPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    container = ProviderContainer(
      overrides: [
        characterCreationProvider
            .overrideWith((ref) => CharacterCreationNotifier()),
      ],
    );
  });

  testWidgets('BasicInfoPage displays initial empty state correctly',
      (WidgetTester tester) async {
    await pumpBasicInfo(tester);

    expect(find.text('Create Character'), findsOneWidget);
    expect(find.text('And what should we call you...'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Shows error message when submitting empty name',
      (WidgetTester tester) async {
    await pumpBasicInfo(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Please fill in your name'), findsOneWidget);
  });

  testWidgets('Updates state when entering character name',
      (WidgetTester tester) async {
    await pumpBasicInfo(tester);

    await tester.enterText(find.byType(TextField), 'Test Character');
    await tester.pump();

    final creationState = container.read(characterCreationProvider);
    expect(creationState.name, equals('Test Character'));
  });
}
