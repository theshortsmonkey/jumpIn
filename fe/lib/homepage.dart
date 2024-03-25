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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            onPressed:_showSignUpScreen,
            child: const Text('Post a ride'),
            )
          ],
        ),
      ),
    );
  }
}