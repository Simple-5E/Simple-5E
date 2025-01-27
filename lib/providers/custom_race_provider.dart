import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/race_repository.dart';
import 'package:simple5e/models/race.dart';

final customRacesProvider =
    StateNotifierProvider<CustomRacesNotifier, AsyncValue<List<Race>>>((ref) {
  return CustomRacesNotifier();
});

class CustomRacesNotifier extends StateNotifier<AsyncValue<List<Race>>> {
  CustomRacesNotifier() : super(const AsyncValue.loading()) {
    _loadCustomRaces();
  }

  Future<void> _loadCustomRaces() async {
    state = const AsyncValue.loading();
    try {
      final races = await RaceRepository.instance.readAllRaces();
      state = AsyncValue.data(races);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCustomRace(Race race) async {
    try {
      await RaceRepository.instance.createRace(race);
      _loadCustomRaces(); // Reload the list after adding
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCustomRace(Race race) async {
    try {
      await RaceRepository.instance.updateRace(race);
      _loadCustomRaces(); // Reload the list after updating
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCustomRace(String name) async {
    try {
      await RaceRepository.instance.deleteRace(name);
      _loadCustomRaces(); // Reload the list after deleting
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Race?> getCustomRace(String name) async {
    try {
      return await RaceRepository.instance.readRace(name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

// Optional: Provider for a single custom race
final customRaceProvider =
    FutureProvider.family<Race?, String>((ref, name) async {
  return RaceRepository.instance.readRace(name);
});
