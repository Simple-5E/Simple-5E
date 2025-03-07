import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:simple5e/data/note_repository.dart';
import 'package:simple5e/features/notes/notes_page.dart';
import 'package:simple5e/models/note.dart';
import 'package:simple5e/providers/notes_provider.dart';

import 'notes_page_test.mocks.dart';

class MockNotesNotifier extends NotesNotifier {
  MockNotesNotifier(List<Note>? notes) : super() {
    state = AsyncValue.data(notes ?? []);
  }

  @override
  Future<void> deleteNote(int noteId) async {
    state = AsyncValue.data([]);
    return Future.value();
  }

  @override
  Future<void> addNote(Note note) async {
    return Future.value();
  }

  @override
  Future<void> updateNote(Note note) async {
    return Future.value();
  }
}

class MockLoadingNotesNotifier extends NotesNotifier {
  MockLoadingNotesNotifier() : super() {
    state = const AsyncValue.loading();
  }
  @override
  Future<void> deleteNote(int noteId) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> addNote(Note note) async {
    state = const AsyncValue.loading();
  }

  @override
  Future<void> updateNote(Note note) async {
    state = const AsyncValue.loading();
  }
}

class MockErrorNotesNotifier extends NotesNotifier {
  MockErrorNotesNotifier() : super() {
    state = AsyncValue.error('Test error', StackTrace.current);
  }
  @override
  Future<void> deleteNote(int noteId) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> addNote(Note note) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }

  @override
  Future<void> updateNote(Note note) async {
    state = AsyncValue.error('Test error', StackTrace.current);
  }
}

@GenerateMocks([NoteRepository])
void main() {
  final mockNotes = [
    Note(
      id: 1,
      characterId: 1,
      title: 'Quest Log',
      content: 'Need to find the lost artifact...',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    ),
    Note(
      id: 2,
      characterId: 1,
      title: 'Important NPCs',
      content: 'The innkeeper seems suspicious...',
      createdAt: DateTime(2023, 1, 2),
      updatedAt: DateTime(2023, 1, 2),
    ),
  ];

  Widget createWidgetUnderTest(List<Note> notes, int characterId) {
    return ProviderScope(
      overrides: [
        notesProvider.overrideWith(
          (ref) => MockNotesNotifier(notes),
        ),
        characterNotesProvider
            .overrideWith((ref, characterId) => Future.value(notes)),
      ],
      child: MaterialApp(
        home: NotesPage(characterId: characterId),
      ),
    );
  }

  group('NotesPage', () {
    testWidgets('shows empty state when no notes exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest([], 1));
      await tester.pumpAndSettle();
      expect(
          find.text('Start adding notes for your character'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('displays notes list when notes exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(mockNotes, 1));
      await tester.pumpAndSettle();

      expect(find.text('Quest Log'), findsOneWidget);
      expect(find.text('Important NPCs'), findsOneWidget);
      expect(find.text('Need to find the lost artifact...'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith(
              (ref) => MockLoadingNotesNotifier(),
            ),
            characterNotesProvider.overrideWith((ref, characterId) =>
                Future.delayed(const Duration(seconds: 1), () => mockNotes)),
          ],
          child: const MaterialApp(
            home: NotesPage(characterId: 1),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message when error occurs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith(
              (ref) => MockErrorNotesNotifier(),
            ),
            characterNotesProvider
                .overrideWith((ref, characterId) => Future.error('Test error')),
          ],
          child: const MaterialApp(
            home: NotesPage(characterId: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows add note dialog when FAB is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(mockNotes, 1));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Note'), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('shows edit dialog with correct data', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(mockNotes, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quest Log'));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsAny);
      expect(find.text('Quest Log'), findsOneWidget);
      expect(find.text('Need to find the lost artifact...'), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(mockNotes, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quest Log'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      expect(find.text('Delete Note'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this note?'),
          findsOneWidget);
    });

    testWidgets('prevents empty note creation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(mockNotes, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Note'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });
  });
}
