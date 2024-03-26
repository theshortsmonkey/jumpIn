import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

Future<Ride> fetchRides() async {
  final response = await http.get('/rides');
  print(response.body);
  final List<dynamic> rides = jsonDecode(response.body);
  if (rides.isNotEmpty) {
    return Ride.fromJson(rides[0] as Map<String, dynamic>);
  } else {
    throw Exception('No rides found');
  }
}
class Ride {
  final int available_Seats;
  // final String id;
  // final String to;
  // final String from;
  // final String driver_username;
  // final String rider_usernames;

  const Ride ({
  required this.available_Seats
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      available_Seats: json['available_Seats'] as int,
    );

  }
}

class GetRide extends StatefulWidget {
  const GetRide({super.key});

  @override
  State<GetRide> createState() => _GetRideState();
}

class _GetRideState extends State<GetRide>{
  late Future<Ride> futureRide;

  @override
  void initState() {
    super.initState();
    futureRide = fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Ride>(
          future: futureRide,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Text('${snapshot.data!.available_Seats} seats available');
          } else {
            return Text('No data');
          }

          },
        ),
      )
    );
  }
}





