import 'package:flutter/material.dart';
import './api.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void _setDefaultUser() async {
    final futureUser = fetchUserByUsername('testUSername1');
    futureUser.then((user) {
    context.read<AuthState>().setUser(user);
      Navigator.of(context).pushNamed('/profile');
    });
  }
  void _showSignUpScreen() {
  Navigator.of(context).pushNamed('/signup');
  }
  void _showLoginPage() {
  Navigator.of(context).pushNamed('/login');
  }
  void _showPostRideScreen() {
  Navigator.of(context).pushNamed('/postride');
  }
  void _showRidesPage() {
  Navigator.of(context).pushNamed('/allrides');
  }
  void _showProfilePage() {
  Navigator.of(context).pushNamed('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyleL = theme.textTheme.bodyLarge;
    final titleStyleL = theme.textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: Text(widget.title),
                actions: [
                IconButton(
                icon : const Icon(Icons.login_outlined),
                onPressed:_setDefaultUser ,
                ),
                IconButton(
                icon : const Icon(Icons.verified_user_rounded),
                onPressed:_showProfilePage ,
                ),
                IconButton(
                icon : const Icon(Icons.car_rental),
                onPressed:_showRidesPage ,
                ),
                IconButton(
                icon : const Icon(Icons.login),
                onPressed:_showLoginPage ,
                ),
                IconButton(
                icon : const Icon(Icons.report),
                onPressed:_showSignUpScreen ,
                )
                
      ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            FilledButton(
                style:FilledButton.styleFrom(
                  minimumSize: const Size(400, 200)
                ),
            onPressed:_showSignUpScreen,
            child: Text(
              'Find a ride',
              style: titleStyleL),
            ),
            const SizedBox(height:30),
            ElevatedButton(
               style:ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 200)
                ),
            onPressed:_showPostRideScreen,
            child: Text(
              'Post a ride',
              style: titleStyleL
            ),
            )
          ],
        ),
      ),
    );
  }
}