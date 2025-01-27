import 'package:flutter/material.dart';

class ClassImageWidget extends StatelessWidget {
  final String className;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ClassImageWidget({
    super.key,
    required this.className,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  Future<bool> _checkAssetExists(BuildContext context, String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAssetExists(
        context,
        'assets/classes/${className.toLowerCase()}.webp',
      ),
      builder: (context, snapshot) {
        final String imagePath = snapshot.data == true
            ? 'assets/classes/${className.toLowerCase()}.webp'
            : 'assets/classes/custom.webp';
        return Image(
          image: AssetImage(imagePath),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}
