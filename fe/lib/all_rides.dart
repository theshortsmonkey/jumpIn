import 'package:flutter/material.dart';
import './ride_card.dart';
import './classes/get_ride_class.dart';
import './api.dart';

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
                  return RideCard(ride: ride);
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