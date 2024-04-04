import 'package:flutter/material.dart';
import './api.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class UploadImageForm extends StatefulWidget {
  const UploadImageForm({super.key});

  @override
  State<UploadImageForm> createState() => _UploadImageForm();
}


class _UploadImageForm extends State<UploadImageForm> {
  final _imageUrlController = TextEditingController();
  String _imageUrl = '';
  
  void _handleUploadPic() async {  
    try {
    final currUser = context.read<AuthState>().userInfo;
      final uploadResponse = await uploadUserProfilePic(currUser.username,_imageUrlController.text);
    print(uploadResponse);
    // Navigator.of(context).pushNamed('/profile');
    } catch (e) {
      print(e);
      setState(() {
        // _isUserExist = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return 
    Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Upload a new profile picture', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'image url'),
              onChanged: (value) {
              setState(() {
                _imageUrl = _imageUrlController.text;
              });
              },
            ),
          ),
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 70,
                backgroundImage: _imageUrl != '' ? AssetImage(_imageUrl) : null,
              ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _handleUploadPic,
            child: const Text('Upload image'),
          ),
        ],
      ),
    );
  }
itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}
