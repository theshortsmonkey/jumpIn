import 'package:flutter/material.dart';
import "classes/post_ride_class.dart";
import './classes/get_ride_class.dart';

class RideCard extends StatelessWidget {
  final ride;
  const RideCard({
    super.key,
    required this.ride
  });

  @override
  Widget build(BuildContext context) {    
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("${ride.id}"),
                Text("${ride.id}"),
              ]
            ),
            Text("${ride.id}"),
            Text("${ride.id}"),
          ]
           
        ),
      ),
    );
  }
}