import 'package:flutter/material.dart';
import './sign_up_form.dart';
import "./appbar.dart";

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
              title: 'jumpIn',
              onMainPagePressed: () {
                Navigator.of(context).pushNamed('/');
              },
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