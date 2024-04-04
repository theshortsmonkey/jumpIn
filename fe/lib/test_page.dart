import 'package:fe/post_ride_form.dart';
import 'package:flutter/material.dart';
import "classes/post_ride_class.dart";
import './classes/get_ride_class.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Ride postedRide = ModalRoute.of(context)!.settings.arguments as Ride;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('TEST PAGE'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Text ('${postedRide.id}'),
          ),
        ),
      ),
    );
  }
}