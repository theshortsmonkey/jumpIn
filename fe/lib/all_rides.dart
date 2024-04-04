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
  late Future<List<Ride>> futureRides;
  final _formKey = GlobalKey<FormState>();
  final toController = TextEditingController();
  final fromController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureRides = fetchRides();
  }

  Future<void> _filterRides({
    String? to,
    String? from,
    String? date_and_time,
    int? price,
    int? available_seats,
    int? carbon_emissions
  }) async {
    // Fetch rides based on the provided criteria
    setState(() {
      futureRides = fetchRides(
        to: to,
        from: from,
        date_and_time: date_and_time,
        price: price,
        available_seats: available_seats,
        carbon_emissions: carbon_emissions
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('jumpIn'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: fromController,
                    decoration: InputDecoration(
                      hintText: 'Start Point',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: toController,
                    decoration: InputDecoration(
                      hintText: 'End Point',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
                _filterRides(
                  to: toController.text,
                  from: fromController.text
                );
            },
            child: Text('Filter'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState((){
                _filterRides();
              });
            },
            child: Text('Clear'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Ride>>(
                future: futureRides,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Use ListView.builder to loop through snapshot.data and render a card for each ride
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
          ),
        ],
      ),
    );
  }
}