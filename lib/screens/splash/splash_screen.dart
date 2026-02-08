import 'package:flutter/material.dart';
import 'package:jukebox/screens/auth/login_screen.dart';
import 'package:jukebox/screens/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  void nextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if (supabase.auth.currentSession == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FlutterLogo(size: 150)));
  }
}
