import 'package:flutter/material.dart';
import 'package:jukebox/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  bool loading = false;

  void logout() async {
    setState(() {
      loading = true;
    });
    try {
      await supabase.auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (context) => false,
      );
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = supabase.auth.currentUser?.email ?? 'No Email';
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Text("Hello $email"),
          SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: Text("Logout"),
          ),

          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            child: Text("Start Jamming (Create Lobby)"),
          ),
        ],
      ),
    );
  }
}
