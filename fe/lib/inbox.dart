import 'package:flutter/material.dart';
import './classes/get_message_class.dart';
import './api.dart';
import './message_card.dart';
import 'package:provider/provider.dart';
import "./auth_provider.dart";

class GetMessage extends StatefulWidget {
  const GetMessage({super.key});

  @override
  State<GetMessage> createState() => _GetMessageState();
}

class _GetMessageState extends State<GetMessage> {
  late Future<List<Message>> futureMessages;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthState>(context, listen: false);
    final currUser = provider.userInfo;
    futureMessages = fetchMessagesByUsername(currUser.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('jumpIn'),
      ),
      body: Center(
          child: FutureBuilder<List<Message>>(
              future: futureMessages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                  //} else if (snapshot.hasError) {
                  //return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Message message = snapshot.data![index];

                      return MessageCard(message: message);
                    },
                  );
                } else {
                  return const Text('No messages');
                }
              })),
    );
  }
}
