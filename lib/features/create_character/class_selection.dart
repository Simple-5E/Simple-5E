import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/classes.dart';
import 'package:simple5e/features/create_character/name_selection.dart';
import 'package:simple5e/features/create_character/custom_class_form.dart';
import 'package:simple5e/features/create_character/class_details.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

final currentClassPageProvider = StateProvider<int>((ref) => 0);

class ClassSelection extends ConsumerWidget {
  final Race selectedRace;
  final PageController _pageController = PageController();

  ClassSelection({super.key, required this.selectedRace});

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
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customClasses = ref.watch(customClassesProvider);
    final currentPage = ref.watch(currentClassPageProvider);

    return Scaffold(
      body: customClasses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (customClasses) {
          final allClasses = [...classes, ...customClasses];
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: allClasses.length + 1,
                onPageChanged: (index) {
                  ref.read(currentClassPageProvider.notifier).state = index;
                },
                itemBuilder: (context, index) {
                  if (index == allClasses.length) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: const Text(
                              'Create Custom Class',
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
                                  'Create Your Own Class',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Design a unique class with custom abilities and features',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final customClass =
                                        await Navigator.push<CharacterClass>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomClassForm(),
                                      ),
                                    );
                                    if (customClass != null &&
                                        context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NameSelection(
                                            selectedRace: selectedRace,
                                            selectedClass: customClass,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Create Custom Class'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ClassDetails(characterClass: allClasses[index]);
                },
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: _buildPageIndicator(
                    context, allClasses.length + 1, currentPage),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: currentPage == allClasses.length
                    ? const SizedBox.shrink()
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NameSelection(
                                selectedRace: selectedRace,
                                selectedClass: allClasses[currentPage],
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
                          'Choose ${allClasses[currentPage].name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
