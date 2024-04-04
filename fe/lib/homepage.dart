import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  void _showInbox() {
    Navigator.of(context).pushNamed('/inbox');
  }
  void _handleLogout() {
    context.read<AuthState>().logout();
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge;
    final isLoggedIn = context.watch<AuthState>().isAuthorized;
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  leading: ClipOval(
    child: Transform.scale(
      scale:1.6,
    child: Container(
      width: 40.0, 
      height: 40.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("../web/icons/logo.png"), 
          fit: BoxFit.cover,
          alignment: Alignment(-0.2, -0.2),
        ),
      ),
    ),)
  ),
         title: Text(widget.title),
                actions: [
                IconButton(
                icon : const Icon(Icons.verified_user),
                onPressed:_setDefaultUser ,
                ),
                if(isLoggedIn)
                IconButton(
                icon : const Icon(Icons.account_box_outlined),
                onPressed:_showProfilePage ,
                ),
                if(!isLoggedIn)
                IconButton(
                icon : const Icon(Icons.login),
                onPressed:_showLoginPage ,
                ),
                if(isLoggedIn)
                IconButton(
                icon : const Icon(Icons.logout),
                onPressed:_handleLogout ,
                ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: _showInbox,
          )
      ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../web/background/background.png"), 
            fit: BoxFit.cover, 
          ),
        ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Column(
                children: [
             Text(
                'Trust who you travel with',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  background: Paint()
                    ..strokeWidth = 60.0
                    ..color = Colors.green
                    ..style = PaintingStyle.stroke
                    ..strokeJoin = StrokeJoin.round,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'We take the time to get to know each of our members. We check reviews, profiles and IDs, so you know who you’re travelling with and can book your ride at ease on our platform.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              ],)
            ),
            FilledButton(
                style:FilledButton.styleFrom(
                  minimumSize: const Size(200, 100),
                  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50), 
      side: const BorderSide(color: Colors.white, width:4),
    ),
                ),
                // if logged in show rides page, if not show sign up page
            onPressed:isLoggedIn ? _showRidesPage : _showSignUpScreen,
            child: Text(
              'Find a ride',
              style: titleStyle),
            ),
            const SizedBox(height:30),
            //only if logged in show the post rides
            if (isLoggedIn) 
            ElevatedButton(
               style:ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 100),
                  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
      side: const BorderSide(color: Color.fromARGB(255, 0, 78, 3), width:4),
       ),
                ),
            onPressed:_showPostRideScreen,
            child: Text(
              'Post a ride',
              style: titleStyle
            ),
            )
          ]
        ),
      ),
    ));
  }
}
