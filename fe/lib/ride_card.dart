import 'package:flutter/material.dart';
import "./ride_data.dart";

class RideCard extends StatelessWidget {
  const RideCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rideData = ModalRoute.of(context)!.settings.arguments as RideData;
    
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
           "${rideData.startPoint}",
        ),
      ),
    );
  }
}