import 'package:flutter/material.dart';
import 'package:titan/features/create_character/class_selection.dart';
import 'dart:convert';
import 'package:titan/models/race.dart';

class RaceSelection extends StatefulWidget {
  const RaceSelection({super.key});

  @override
  State<RaceSelection> createState() => _RaceSelectionState();
}

class _RaceSelectionState extends State<RaceSelection> {
  final PageController _pageController = PageController();
  final List<String> availableRaces = ['dwarf', 'elf', 'halfling', 'human'];
  int currentPage = 0;
  int currentImageIndex = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Race>> loadAllRaces() async {
    List<Race> races = [];
    for (String race in availableRaces) {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/races/$race.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      races.add(Race.fromJson(jsonData));
    }
    return races;
  }

  Widget _buildPageIndicator(int count, int current) {
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
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Race>>(
        future: loadAllRaces(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Race> races = snapshot.data!;
            return Stack(
              children: [
                // Main PageView
                PageView.builder(
                  controller: _pageController,
                  itemCount: races.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                      currentImageIndex = 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    Race race = races[index];
                    return CustomScrollView(
                      slivers: [
                        // App Bar with Race Image
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                              race.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/races/${race.name.toLowerCase()}_$currentImageIndex.webp',
                                  fit: BoxFit.cover,
                                ),
                                // Gradient overlay for better text visibility
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
                                // Image switcher buttons
                                Positioned(
                                  bottom: 60,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            currentImageIndex =
                                                currentImageIndex == 1 ? 2 : 1;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            currentImageIndex =
                                                currentImageIndex == 1 ? 2 : 1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Race Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Race Description
                                Text(
                                  race.description,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),

                                // Quick Stats
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quick Stats',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildQuickStat(
                                        'Ability Bonus',
                                        race.abilityScoreIncrease,
                                      ),
                                      _buildQuickStat('Speed', race.speed),
                                      _buildQuickStat('Size', race.size),
                                      _buildQuickStat(
                                        'Languages',
                                        race.languages,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Special Abilities

                                race.abilities.isNotEmpty
                                    ? Text(
                                        'Special Abilities',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      )
                                    : Text(''),
                                const SizedBox(height: 16),
                                ...race.abilities.map((ability) => Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ability.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(ability.description),
                                          ],
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                    height: 100), // Bottom padding for FAB
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Page Indicator
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: _buildPageIndicator(races.length, currentPage),
                ),
                // Selection Button
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to next step with selected race
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

  Widget _buildQuickStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
