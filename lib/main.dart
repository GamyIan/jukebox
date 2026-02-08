import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
    debugPrint('✅ JukeBox Supabase Initialized');
  } catch (e) {
    debugPrint('❌ Initialization Error: $e');
  }

  runApp(const JukeBoxApp());
}

class JukeBoxApp extends StatelessWidget {
  const JukeBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JukeBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
        // Stable way to set the font and base size
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(fontFamily: 'Nihonium', fontSize: 18),
          bodyMedium: const TextStyle(fontFamily: 'Nihonium', fontSize: 16),
          titleLarge: const TextStyle(fontFamily: 'Nihonium', fontSize: 24),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
