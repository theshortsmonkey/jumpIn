import 'package:flutter/material.dart';
import "./validate_licence_form.dart";

class ValidateLicencePage extends StatelessWidget {
  const ValidateLicencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Licence'),
      ),
      body: const Center(
        child: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (ValidateLicenceForm(submitType: 'patch')),
            
          ),
        ),
        ),
      ),
    );
  }
}