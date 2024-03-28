import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void _showSignUpScreen() {
  Navigator.of(context).pushNamed('/signup');
  }
  void _showPostRideScreen() {
  Navigator.of(context).pushNamed('/postride');
  }
  void _showRidesPage() {
  Navigator.of(context).pushNamed('/allrides');
  }
  void _showUsersPage() {
  Navigator.of(context).pushNamed('/allusers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: Text(widget.title),
                actions: [
                  IconButton(
                icon : const Icon(Icons.verified_user_rounded),
                onPressed:_showUsersPage ,//report page
                ),
                IconButton(
                icon : const Icon(Icons.car_rental),
                onPressed:_showRidesPage ,
                ),
                IconButton(
                icon : const Icon(Icons.login),
                onPressed:_showSignUpScreen ,
                ),
                IconButton(
                icon : const Icon(Icons.report),
                onPressed:_showSignUpScreen ,//report page
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
            child: const Text('Find a ride'),
            ),
            const SizedBox(height:30),
            ElevatedButton(
               style:ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 200)
                ),
            onPressed:_showPostRideScreen,
            child: const Text('Post a ride'),
            )
          ],
        ),
      ),
    );
  }
}