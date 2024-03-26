import 'package:flutter/material.dart';
import "./post_ride_form.dart";
class PostRidePage extends StatelessWidget {
  const PostRidePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Ride'),
      ),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (PostRideForm()),
          ),
        ),
      ),
    );
  }
}