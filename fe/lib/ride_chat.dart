import 'package:flutter/material.dart';
import './chat_card.dart';
import './classes/get_chat_class.dart';
import './api.dart';
//import 'package:provider/provider.dart';
//import "./auth_provider.dart";

class GetRideChat extends StatefulWidget {
  const GetRideChat({super.key});

  @override
  State<GetRideChat> createState() => _GetRideChatState();
}

class _GetRideChatState extends State<GetRideChat> {
  late Future<List<Chat>> futureRideChats;
  late String chatId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //final currUser = provider.userInfo;
    chatId = ModalRoute.of(context)!.settings.arguments as String;
    futureRideChats = fetchMessagesByRideId(chatId, 'username3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('jumpIn')),
      body: Center(
        child: FutureBuilder<List<Chat>>(
          // Update to FutureBuilder<List<Ride>>
          future: futureRideChats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Use ListView.builder to loop through snapshot.data and render a card for each ride
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Chat chat = snapshot.data![index];

                  return ChatCard(chat: chat);
                },
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
    
  }
}
