import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'dart:async';

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

Future<List<Ride>> fetchRides() async {
  final response = await http.get('/rides');
  if (response.isNotEmpty) {
    List<Ride> rides = response.map<Ride>((item) {
      // Ensure each item is correctly interpreted as Map<String, dynamic>
      return Ride.fromJson(item as Map<String, dynamic>);
    }).toList();
    return rides;
  } else {
    throw Exception('No rides found');
  }
}

class Ride 
  final String id;
  
  const Ride ({
  required this.id,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String
    );
  }
  static List<Ride> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<Ride>((json) => Ride.fromJson(json)).toList();
  }
}

class GetRide extends StatefulWidget {
  const GetRide({super.key});

  @override
  State<GetRide> createState() => _GetRideState();
}

class _GetRideState extends State<GetRide>{
  late Future<List<Ride>>futureRides;

  @override
  void initState() {
    super.initState();
    futureRides = fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Ride>>( // Update to FutureBuilder<List<Ride>>
          future: futureRides,
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
                  Ride ride = snapshot.data![index];
                  return ListTile(
                    title: Text('ID: ${ride.id}'),
                  );
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





