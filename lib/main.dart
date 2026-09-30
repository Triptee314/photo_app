
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/saved_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SavedProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
    ],
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'PhotoFlow',

      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),

      themeMode: themeProvider.themeMode,

      home: const SplashScreen(),
    );
  }
}




