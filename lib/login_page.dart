import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 49, 12),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
  color: const Color.fromARGB(255, 103, 150, 122), // açık yeşil kutu rengi
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(255, 3, 43, 1).withAlpha(51), // %20 opaklık
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ],
),

            child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // 🔥 LOGO EKLENDİ 🔥
    Image.asset(
      'assets/images/rexx_logo.png',
      height: 180, // istediğin gibi ayarla
    ),
                const SizedBox(height: 15),
                TextField(
  controller: emailController,
  style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
  decoration: const InputDecoration(
    labelText: 'Email',
    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
    ),
  ),
),
TextField(
  controller: passwordController,
  style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
  decoration: const InputDecoration(
    labelText: 'Password',
    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
    ),
  ),
),


                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 43, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 255, 255)),
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
