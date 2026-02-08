import 'package:flutter/material.dart';
import 'package:jukebox/screens/auth/login_screen.dart';
import 'package:jukebox/screens/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  bool loading = false;
  final supabase = Supabase.instance.client;

  void register() async {
    setState(() {
      loading = true;
    });
    try {
      final result = await supabase.auth.signUp(
        email: email.text,
        password: password.text,
      );

      if (result.user != null && result.session != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (context) => false,
        );
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void login() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (context) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: email,
            decoration: InputDecoration(hintText: "Email"),
          ),
          SizedBox(height: 15),

          TextFormField(
            controller: password,
            decoration: InputDecoration(hintText: "Password"),
          ),
          SizedBox(height: 15),

          loading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: Text("Register"),
                ),
          SizedBox(height: 15),

          TextButton(
            onPressed: () {
              login();
            },
            child: Text("Already have an account? Login now!"),
          ),
        ],
      ),
    );
  }
}
