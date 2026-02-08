// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jukebox/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  } catch (e) {
    print('Initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JukeBox',
      home: const SplashScreen(),
    );
  }
}
