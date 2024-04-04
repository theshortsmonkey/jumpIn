import 'package:fe/upload_image_form.dart';
import 'package:flutter/material.dart';

class UploadProfilePic extends StatelessWidget {
  const UploadProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Profile Pic'),
      ),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: (UploadImageForm()),
          ),
        ),
      ),
    );
  }
}