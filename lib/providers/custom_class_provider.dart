import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/class_repository.dart';
import 'package:simple5e/models/character_class.dart';

final customClassesProvider = StateNotifierProvider<CustomClassesNotifier,
    AsyncValue<List<CharacterClass>>>((ref) {
  return CustomClassesNotifier();
});

class CustomClassesNotifier
    extends StateNotifier<AsyncValue<List<CharacterClass>>> {
  CustomClassesNotifier() : super(const AsyncValue.loading()) {
    loadCustomClasses();
  }

  Future<void> loadCustomClasses() async {
    state = const AsyncValue.loading();
    try {
      final classes = await ClassRepository.instance.readAllClasses();
      state = AsyncValue.data(classes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCustomClass(CharacterClass characterClass) async {
    try {
      await ClassRepository.instance.createClass(characterClass);
      loadCustomClasses(); // Reload the list after adding
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCustomClass(CharacterClass characterClass) async {
    try {
      await ClassRepository.instance.updateClass(characterClass);
      loadCustomClasses(); // Reload the list after updating
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCustomClass(String name) async {
    try {
      await ClassRepository.instance.deleteClass(name);
      loadCustomClasses(); // Reload the list after deleting
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<CharacterClass?> getCustomClass(String name) async {
    try {
      return await ClassRepository.instance.readClass(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Optional: Provider for a single custom class
final customClassProvider =
    FutureProvider.family<CharacterClass?, String>((ref, name) async {
  return ClassRepository.instance.readClass(name);
});
