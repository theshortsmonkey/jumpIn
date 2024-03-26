import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

Future<Ride> fetchRides() async {
  final response = await http.get('/rides');
  print(response.body);
  return Ride.fromJson(jsonDecode(response.body[0]) as Map<String, dynamic>);
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
    return switch (json) {
      {
        'available_Seats' : int available_Seats
      } => 
      Ride(available_Seats: available_Seats),
      _ => throw const FormatException('Nice try Barry'),
    };
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
            if(snapshot.hasData) {
              return Text('${snapshot.data!.available_Seats} you bloody well did it');
            } else {
              throw const FormatException('Nice try, buddy.');
            }
          },
        ),
      )
    );
  }
}





