import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/manage_data/manage_custom_classes_page.dart';
import 'package:simple5e/features/manage_data/manage_custom_races.dart';
import 'package:simple5e/features/manage_data/manage_custom_spells.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.webp',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: const Text('Manage Custom Races'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageCustomRacesPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.grass_sharp),
                  title: const Text('Manage Custom Classes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ManageCustomClassesPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('Manage Custom Spells'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageCustomSpellsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Info'),
              onTap: () {
                Navigator.pop(context);
                _showAppInfo(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/logo.webp',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text('Simple 5E'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('A streamlined 5E character management app.'),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.person, 'Author: scott-the-programmer',
                    onTap: () async => _launchURL('https://scott.murray.kiwi')),
                _buildInfoRow(Icons.code, 'GitHub: Simple-5E/Simple-5E',
                    onTap: () async => _launchURL(
                        'https://github.com/simple-5e/simple-5e.git')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: onTap != null ? Colors.blue : null,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
