import 'package:flutter/material.dart';
import './sign_up_page.dart';
import './welcome.dart';
import './homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jumpIn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'jumpIn'),
      routes: {
        '/': (context) => const MyHomePage(title: 'jumpIn'),
        "/signup" : (context) => const SignUpPage(),
        '/welcome': (context) => const WelcomeScreen(),
      }
    );
  }
} 
