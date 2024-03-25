import 'package:flutter/material.dart';
import './sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (SignUpForm()),
          ),
        ),
      ),
    );
  }
}