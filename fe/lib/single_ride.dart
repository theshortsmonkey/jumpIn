import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import './classes/get_ride_class.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//NEEDS TO BE FIXED - NOT LOADING CURRENTLY

class SingleRide extends StatefulWidget {
  //final String rideId;
  const SingleRide({super.key});

  @override
  State<SingleRide> createState() => _SingleRideState();
}

class _SingleRideState extends State<SingleRide> {
  late Future<Ride> futureRide;
  late String rideId ='';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (rideId.isEmpty) {
      rideId = ModalRoute.of(context)!.settings.arguments as String;
      print(rideId);
      futureRide = fetchRideById(rideId); //pass rideId
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final titleStyleL = theme.textTheme.titleLarge;
    final titleStyleM = theme.textTheme.titleMedium;
    final titleStyleS = theme.textTheme.titleSmall;
    List<LatLng> polylinePoints = [
      LatLng(53.47764, -2.23892),//start
      LatLng(51.51408, -0.10648), //end
    ];

    
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('jumpIn')),
      body: Center(
        child: FutureBuilder<Ride>(
            future: futureRide,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final rideData = snapshot.data;
                final String imgURL = 'http://localhost:1337/users/${rideData?.driverUsername}/image';
                // Use ListView.builder to loop through snapshot.data and render a card for each ride
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            IntrinsicWidth(
                              child: Column(
                                
                                children: [
                                  itemProfile('Start', '${rideData?.from}', CupertinoIcons.arrow_right_circle),
                                  itemProfile('End', '${rideData?.to}', CupertinoIcons.flag_circle_fill),
                                  itemProfile('Date', '${rideData?.dateTime?.substring(0,10)}', CupertinoIcons.calendar_today),
                                  itemProfile('Time', '${rideData?.dateTime?.substring(11,16)}', CupertinoIcons.clock),
                                  itemProfile('Available Seats', '${rideData?.availableSeats}', CupertinoIcons.person_2),
                                  itemProfile('Price', '${rideData?.price}', CupertinoIcons.money_pound_circle),
                                  itemProfile('Total Carbon', '${rideData?.carbonEmissions}', CupertinoIcons.leaf_arrow_circlepath),
                              ],),
                            ),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                height: 300,
                                child: map()
                                ),
                            ))
                            // Expanded(
                            //   child: 
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    driverProfile(imgURL, rideData),
                  ],
                
                );
              } else {
                return Text('No data');
              }
            }),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    final theme = Theme.of(context);
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData),
          const SizedBox(width: 10),
          Text(title,
            style: theme.textTheme.headlineSmall
          ),
          const SizedBox(width: 8),
          Text(subtitle,
            style: theme.textTheme.bodyLarge
          )
        ],
      ),
    );
  }

  driverProfile(imgURL, rideData){
    final theme = Theme.of(context);

    return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(children: [
                new CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imgURL),
              ),
              SizedBox(height: 10),
              FilledButton(onPressed: (){}, child: Text('Message'))
              ],),
              // Add some spacing between the image and the text
              Container(width: 20),
              // Add an expanded widget to take up the remaining horizontal space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add some spacing between the top of the card and the title
                    Container(height: 5),
                    // Add a title widget
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Driver:",
                          style: theme.textTheme.headlineSmall
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '${rideData.driverUsername}',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // Add a subtitle widget
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                        "Rating:",
                        style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${rideData.driverRating}",
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    // Add some spacing between the subtitle and the text
                    Container(height: 10),
                    // Add a text widget to display some text
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }

  map(){
    return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(51.509364, -0.128928),
      initialZoom: 3.4,
    ),
    
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      PolylineLayer(
      polylines: [
      Polyline(
        points: [LatLng(53.47764, -2.23892), LatLng(51.51408, -0.10648)],
        color: Colors.red,
        strokeWidth: 10
      ),
      ],
      ),
      // RichAttributionWidget(
      //   attributions: [
      //     TextSourceAttribution(
      //       'OpenStreetMap contributors',
      //       onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
      //     ),
      ],
      );
  }
}
