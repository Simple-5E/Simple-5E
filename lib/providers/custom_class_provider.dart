import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/class_repository.dart';
import 'package:simple5e/models/character_class.dart';

final customClassesProvider = StateNotifierProvider<CustomClassesNotifier,
    AsyncValue<List<CharacterClass>>>((ref) {
  return CustomClassesNotifier();
});

class CustomClassesNotifier
    extends StateNotifier<AsyncValue<List<CharacterClass>>> {
  final ClassRepository _repository = ClassRepository.instance;
  
  CustomClassesNotifier() : super(const AsyncValue.loading()) {
    loadCustomClasses();
  }

  Future<void> loadCustomClasses() async {
    state = const AsyncValue.loading();
    try {
      final classes = await _repository.readAllClasses();
      state = AsyncValue.data(classes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCustomClass(CharacterClass characterClass) async {
    try {
      await _repository.createClass(characterClass);
      loadCustomClasses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCustomClass(CharacterClass characterClass) async {
    try {
      await _repository.updateClass(characterClass);
      loadCustomClasses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCustomClass(String name) async {
    try {
      await _repository.deleteClass(name);
      loadCustomClasses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<CharacterClass?> getCustomClass(String name) async {
    try {
      return await _repository.readClass(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Provider for a single custom class
final customClassProvider =
    FutureProvider.family<CharacterClass?, String>((ref, name) async {
  try {
    return await ClassRepository.instance.readClass(name);
  } catch (e) {
    throw Exception('Failed to load class: $e');
  }
});
