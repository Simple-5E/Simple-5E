import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/class_selection.dart';
import 'package:simple5e/features/create_character/custom_race_form.dart';
import 'package:simple5e/features/create_character/race_details.dart';
import 'dart:convert';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/providers/custom_race_provider.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class RaceSelection extends ConsumerWidget {
  final PageController _pageController = PageController();
  final List<String> availableRaces = [
    'dwarf',
    'half-orc',
    'elf',
    'dragonborn',
    'human',
    'gnome',
    'half-elf',
    'halfling',
    'tiefling'
  ];
  RaceSelection({super.key});

  Future<List<Race>> loadAllRaces(BuildContext context, WidgetRef ref) async {
    List<Race> races = [];

    for (String race in availableRaces) {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/races/$race.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      races.add(Race.fromJson(jsonData));
    }

    final customRacesValue = ref.read(customRacesProvider);
    final customRaces = customRacesValue.when(
      data: (races) => races,
      loading: () => <Race>[],
      error: (_, __) => <Race>[],
    );
    races.addAll(customRaces);

    return races;
  }

  Widget _buildPageIndicator(BuildContext context, int count, int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      body: FutureBuilder<List<Race>>(
        future: loadAllRaces(context, ref),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Race> races = snapshot.data!;
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: races.length + 1,
                  onPageChanged: (index) {
                    ref.read(currentPageProvider.notifier).state = index;
                  },
                  itemBuilder: (context, index) {
                    if (index == races.length) {
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: 300,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: const Text(
                                'Create Custom Race',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              background: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withAlpha(178),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      size: 80,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black54,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 24),
                                  Text(
                                    'Create Your Own Race',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Design a unique race with custom abilities and traits',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final customRace =
                                          await Navigator.push<Race>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomRaceForm(),
                                        ),
                                      );
                                      if (customRace != null &&
                                          context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClassSelection(
                                              selectedRace: customRace,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text(
                                      'Create Custom Race',
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      minimumSize: const Size.fromHeight(50),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return RaceDetails(
                      race: races[index],
                    );
                  },
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: _buildPageIndicator(
                      context, races.length + 1, currentPage),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: currentPage == races.length
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassSelection(
                                  selectedRace: races[currentPage],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Choose ${races[currentPage].name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
