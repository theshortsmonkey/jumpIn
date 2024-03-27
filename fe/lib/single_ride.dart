import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './user_data.dart';
import 'package:flutter/services.dart';

//change profile page to single ride page in same template

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/user.JPG'),
            ),
            const SizedBox(height: 20),
            itemProfile('Name', '${userData.firstName} ${userData.lastName}', CupertinoIcons.person),
            const SizedBox(height: 10),
            itemProfile('Username', '${userData.username}', CupertinoIcons.location),
            const SizedBox(height: 10),
            itemProfile('Email', '${userData.email}', CupertinoIcons.mail),
            const SizedBox(height: 20,),
            itemProfile('Phone', '${userData.phoneNumber}', CupertinoIcons.phone),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Edit Profile')
              ),
            )
          ],
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );

  }
}


