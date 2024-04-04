import 'package:flutter/material.dart';
import "./validate_car_form.dart";

class ValidateCarPage extends StatelessWidget {
  const ValidateCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Car'),
      ),
      body: const Center(
        child: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (ValidateCarFrom(submitType: 'patch')),
            
          ),
        ),
        ),
      ),
    );
  }
}