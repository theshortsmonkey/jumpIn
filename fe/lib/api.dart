import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

Future<List<Ride>> fetchRides() async {
  final response = await http.get('/rides');
  if (response.isNotEmpty) {
    return Ride.fromJsonList(response as List<Map<String, dynamic>>);
  } else {
    throw Exception('No rides found');
  }
}
class Ride {
  final String id;
  final String to;
  final String from;
  final String driver_username;
  final List rider_usernames;

  const Ride ({
  required this.id,
  required this.to,
  required this.from,
  required this.driver_username,
  required this.rider_usernames,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String,
      to: json['to'] as String,
      from: json['from'] as String,
      driver_username: json['driver_username'] as String,
      rider_usernames: List<String>.from(json['rider_usernames'])
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
  late Future<List<Ride>> futureRides;

  @override
  void initState() {
    super.initState();
    futureRides = fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Ride>>( 
          future: futureRides,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
                print(snapshot.data);
              // Use ListView.builder to handle a list of data
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Ride ride = snapshot.data![index];
                  return ListTile(
                    title: Text('To: ${ride.to}, From: ${ride.from}'),
                    subtitle: Text('Driver: ${ride.driver_username}, Rider Usernames: ${ride.rider_usernames.join(', ')}'),
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




