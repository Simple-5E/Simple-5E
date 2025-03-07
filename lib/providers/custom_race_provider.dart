import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/race_repository.dart';
import 'package:simple5e/models/race.dart';

final customRacesProvider =
    StateNotifierProvider<CustomRacesNotifier, AsyncValue<List<Race>>>((ref) {
  return CustomRacesNotifier();
});

class CustomRacesNotifier extends StateNotifier<AsyncValue<List<Race>>> {
  final RaceRepository _repository = RaceRepository.instance;

  CustomRacesNotifier() : super(const AsyncValue.loading()) {
    loadCustomRaces();
  }

  Future<void> loadCustomRaces() async {
    state = const AsyncValue.loading();
    try {
      final races = await _repository.readAllRaces();
      state = AsyncValue.data(races);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCustomRace(Race race) async {
    try {
      await _repository.createRace(race);
      loadCustomRaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCustomRace(Race race) async {
    try {
      await _repository.updateRace(race);
      loadCustomRaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCustomRace(String name) async {
    try {
      await _repository.deleteRace(name);
      loadCustomRaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Race?> getCustomRace(String name) async {
    try {
      return await _repository.readRace(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Provider for a single custom race
final customRaceProvider =
    FutureProvider.family<Race?, String>((ref, name) async {
  try {
    return await RaceRepository.instance.readRace(name);
  } catch (e) {
    throw Exception('Failed to load race: $e');
  }
});
