import 'package:flutter/material.dart';

class RacePortrait extends StatelessWidget {
  final String raceName;
  final int imageIndex;

  const RacePortrait({
    super.key,
    required this.raceName,
    required this.imageIndex,
  });

  Future<bool> _imageExists(String assetPath, BuildContext context) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _imageExists(
          'assets/races/${raceName.toLowerCase()}_$imageIndex.webp', context),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.asset(
            'assets/races/${raceName.toLowerCase()}_$imageIndex.webp',
            fit: BoxFit.cover,
          );
        } else {
          return Container(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
            child: const Center(
              child: Icon(
                Icons.question_mark,
                size: 80,
                color: Colors.white54,
              ),
            ),
          );
        }
      },
    );
  }
}
