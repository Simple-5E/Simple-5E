import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/note_repository.dart';
import 'package:simple5e/models/note.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>(
  (ref) => NotesNotifier(),
);

final characterNotesProvider =
    FutureProvider.family<List<Note>, int>((ref, characterId) async {
  try {
    final repository = NoteRepository.instance;
    return repository.readNotesForCharacter(characterId);
  } catch (e) {
    throw Exception('Failed to load notes: $e');
  }
});

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository _repository = NoteRepository.instance;

  NotesNotifier() : super(const AsyncValue.loading()) {
    loadNotes();
  }
  
  Future<void> loadNotes() async {
    // This is a placeholder since we don't have a method to load all notes
    // In a real implementation, you might want to load all notes for all characters
    state = const AsyncValue.data([]);
  }

  Future<void> addNote(Note note) async {
    try {
      await _repository.createNote(note);
      // We don't update the state here since we're using characterNotesProvider
      // to load notes for a specific character
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _repository.updateNote(note);
      // We don't update the state here since we're using characterNotesProvider
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      // We don't update the state here since we're using characterNotesProvider
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> loadNotesForCharacter(int characterId) async {
    try {
      final notes = await _repository.readNotesForCharacter(characterId);
      state = AsyncValue.data(notes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
