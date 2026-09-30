import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/saved_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

 @override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  final savedProvider = context.watch<SavedProvider>();
  final themeProvider = context.watch<ThemeProvider>();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
    ),

    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 40,
          child: Icon(
            Icons.person,
            size: 40,
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: Text(
            user?.email ?? 'No email',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        const SizedBox(height: 30),

        Card(
          child: ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved photos'),
            trailing: Text(
              '${savedProvider.savedPhotos.length}',
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Theme',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        RadioListTile<ThemeMode>(
          title: const Text('Light'),
          value: ThemeMode.light,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
           
            if (value != null) {
              themeProvider.setTheme(value);
            }
          },
        ),

        RadioListTile<ThemeMode>(
          title: const Text('Dark'),
          value: ThemeMode.dark,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) {
              themeProvider.setTheme(value);
            }
          },
        ),

        RadioListTile<ThemeMode>(
          title: const Text('System'),
          value: ThemeMode.system,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) {
              themeProvider.setTheme(value);
            }
          },
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            if (!context.mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    ),
  );
}
}