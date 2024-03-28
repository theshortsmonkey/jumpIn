import 'package:flutter/material.dart';
import './sign_up_page.dart';
import 'profile_page.dart';
import './homepage.dart';
import "post_ride_page.dart";
import "./test_page.dart";
import './all_rides.dart';
import './single_ride.dart';
import 'package:google_fonts/google_fonts.dart';


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
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        )
      ),
      home: const MyHomePage(title: 'jumpIn'),
      routes: {
        "/signup" : (context) => const SignUpPage(),
        '/profile': (context) => const ProfileScreen(),
        "/postride" : (context) => const PostRidePage(),
        "/test": (context) => const TestPage(),
        "/allrides": (context) => const GetRide(),
        '/singleridetest': (context) => const SingleRide() 
        }
    );
  }
} 
