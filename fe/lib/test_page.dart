import 'package:flutter/material.dart';
import "./ride_data.dart";

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rideData = ModalRoute.of(context)!.settings.arguments as RideData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('TEST PAGE'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Text (rideData.endPoint),
          ),
        ),
      ),
    );
  }
}