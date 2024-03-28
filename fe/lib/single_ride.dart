import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import './classes/get_ride_class.dart';

//change profile page to single ride page in same template

class SingleRide extends StatefulWidget {
  const SingleRide({super.key});

  @override
  State<SingleRide> createState() => _SingleRideState();
 } 

 class _SingleRideState extends State<SingleRide>{
   late Future<Ride> futureRide;
   late String rideId;

  @override
    void initState() {
      super.initState();
      rideId = ModalRoute.of(context)!.settings.arguments as String;

      futureRide = fetchRideById(rideId);
    }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: const Text('jumpIn')
      ),
      body: Center(
        child: FutureBuilder<Ride>(
          future: futureRide,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {

              // Use ListView.builder to loop through snapshot.data and render a card for each ride
              return Text('${snapshot.data?.to}');
              
            } else {
              return Text('No data');
            }
          }
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


