import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/providers/providers.dart';

class BasicInfoPage extends ConsumerWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creationState = ref.watch(characterCreationProvider);
    final creationNotifier = ref.read(characterCreationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Character', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'And what should we call you...',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 24),
              _buildTextField(
                label: 'Character Name',
                value: creationState.name,
                onChanged: creationNotifier.updateName,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  if (creationState.name.isNotEmpty) {
                    // Navigate to the next page
                    Navigator.pushNamed(
                        context, '/next_page'); // Replace with actual route
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in your name')),
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: value),
      ),
    );
  }
}
