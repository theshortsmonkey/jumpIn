import 'package:flutter/material.dart';
import './user_data.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Text(
              'Welcome! ${userData.firstName}',
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ),
    );
  }
}