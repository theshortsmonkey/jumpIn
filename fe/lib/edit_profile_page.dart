import 'package:flutter/material.dart';
import './sign_up_form.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (SignUpForm(submitType: 'patch')),
          ),
        ),
        ),
      ),
    );
  }
}