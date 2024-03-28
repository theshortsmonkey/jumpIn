import 'package:flutter/material.dart';
import './user_card.dart';
import './classes/get_user_class.dart';
import './api.dart';

class GetUser extends StatefulWidget {
  const GetUser({super.key});

  @override
  State<GetUser> createState() => _GetUserState();
}

class _GetUserState extends State<GetUser>{
  late Future<List<User>>futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<User>>( // Update to FutureBuilder<List<Ride>>
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {

              // Use ListView.builder to handle a list of data
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data![index];
                  return UserCard(user: user);
                },
              );
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }
}