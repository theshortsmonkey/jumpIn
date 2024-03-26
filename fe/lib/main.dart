import 'package:flutter/material.dart';
import './sign_up_page.dart';
import 'profile_page.dart';
import './homepage.dart';
import "post_ride_page.dart";
import "./test_page.dart";

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
      home: const MyHomePage(title: 'jumpIn'),
      routes: {
        "/signup" : (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
        "/postride" : (context) => const PostRidePage(),
        "/test": (context) => const TestPage()
        }
    );
  }
} 
