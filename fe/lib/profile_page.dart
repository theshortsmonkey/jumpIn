import 'dart:html';
import './login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'classes/get_user_class.dart';
import 'package:provider/provider.dart';
import "./auth_provider.dart";
import './api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
bool isDriver = false;
bool _isDeleted = false;
bool _areYouSure = false;
String _deleteButtonText ='Delete your account';
dynamic userData;
@override
void initState() {
  super.initState();
    final provider = Provider.of<AuthState>(context, listen:false);
    userData = provider.userInfo;
    if (userData.identity_verification_status && userData.driver_verification_status) {
      isDriver = true;
    }
}

void _handleDelete () async {
  if(_areYouSure){
    deleteUser(userData);
  setState(() {
    _isDeleted = true;
  });
  await Future.delayed(const Duration(seconds: 5), () {
    context.read<AuthState>().logout();
    Navigator.of(context).pushNamed('/');
  });
  }else{
  setState(() {
  _areYouSure = true;
  _deleteButtonText = 'Your account is going to be destroyed! Are you sure?';
});}

  
}

  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthState>().userInfo;
    final imgUrl = "http://localhost:1337/users/${userData.username}/image";
    return context.read<AuthState>().isAuthorized
    ? Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: const Text('jumpIn')
      ),
      body: 
       _isDeleted
       ?
      Center(
        child: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [itemProfile('Account Deleted','' ,CupertinoIcons.person_badge_minus)],
          ),
        ),
        ),
      )
       :
      Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/editprofile');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Edit Profile')
                ),
              ),
              // const SizedBox(height: 10),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).pushNamed('/uploadProfilePic');
              //       },
              //       style: ElevatedButton.styleFrom(
              //         padding: const EdgeInsets.all(15),
              //       ),
              //       child: const Text('Upload Profile Picture')
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isDriver ? Colors.green : Colors.amberAccent,
                  shape: BoxShape.circle,
                  ),
                child: new CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(imgUrl),
                  ),
              ),
              const SizedBox(height: 20),
              itemProfile('Name Lastname', '${userData.firstName} ${userData.lastName}', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Username', '${userData.username}', CupertinoIcons.location),
              const SizedBox(height: 10),
              itemProfile('Email', '${userData.email}', CupertinoIcons.mail),
              const SizedBox(height: 20,),
              itemProfile('Phone', '${userData.phoneNumber}', CupertinoIcons.phone),
              const SizedBox(height: 20,),
              itemProfile('Bio', '${userData.bio}', CupertinoIcons.profile_circled),
              const SizedBox(height: 20),
              userData.identity_verification_status ? 
              itemProfile('Licence valid: ', '${userData.identity_verification_status}', CupertinoIcons.check_mark)
              :
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/validatelicence');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Validate Licence')
                ),
              ),
              const SizedBox(height: 20,),
              userData.car != null ?
              carBox(userData.car)
                          :
                          SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/validatecar');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Validate vehicle')
                ),
          ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _handleDelete,
                    style:ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: Text(_deleteButtonText)
                )
              ),
          ]
          ),
        )
      ),
    )
    : const LoginPage();
  }

  carBox(car) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.lightGreen.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: Column (
        children: [
          const SizedBox(height: 20,),
          itemProfile('Registration number: ', '${car["reg"]}', CupertinoIcons.check_mark),
          const SizedBox(height: 20,),
          itemProfile('Make: ', '${car["make"]}', CupertinoIcons.check_mark),
          const SizedBox(height: 20,),
          itemProfile('Colour: ', '${car["colour"]}', CupertinoIcons.check_mark),
          const SizedBox(height: 20,),
          itemProfile('Tax Due Date: ', '${car["tax_due_date"]}', CupertinoIcons.check_mark),
        ]
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
                color: Colors.lightGreen.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );

  }
}


