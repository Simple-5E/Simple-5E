import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/note_repository.dart';
import 'package:simple5e/models/note.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>(
  (ref) => NotesNotifier(NoteRepository.instance),
);

final characterNotesProvider =
    FutureProvider.family<List<Note>, int>((ref, characterId) async {
  final repository = NoteRepository.instance;
  return repository.readNotesForCharacter(characterId);
});

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository _repository;

  NotesNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> addNote(Note note) async {
    try {
      await _repository.createNote(note);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _repository.updateNote(note);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
