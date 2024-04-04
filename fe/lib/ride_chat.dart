import 'package:flutter/material.dart';
import './chat_card.dart';
import './classes/get_chat_class.dart';
import './api.dart';
import 'package:provider/provider.dart';
import "./auth_provider.dart";

class GetRideChat extends StatefulWidget {
  const GetRideChat({super.key});

  @override
  State<GetRideChat> createState() => _GetRideChatState();
}

class _GetRideChatState extends State<GetRideChat> {
  late Future<List<Chat>> futureRideChats;
  late String chatId;
  var rideDetails;
  dynamic _chats;
  final _msgTextController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<AuthState>(context, listen: false);
    final currUser = provider.userInfo;
    chatId = ModalRoute.of(context)!.settings.arguments as String;
    futureRideChats = fetchMessagesByRideId(chatId, currUser.username);
    rideDetails = fetchRideById(chatId);
  }
  void _postMessage(message, chatId){
    postMessage(message, chatId);
    setState((){
      _chats = futureRideChats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthState>().userInfo;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('jumpIn')),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _msgTextController,
                      decoration: InputDecoration(hintText: "Send a message"),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(onPressed: () {
              final message = {
                "from": userData.username,
                "to": "testUSername27",
                "message": _msgTextController.text 
              };
              print(message);
              print(chatId);
              fetchMessagesByRideId(chatId, userData.username);
              _postMessage(message, chatId);
              
              //post message(_msgTextController, )
            }, child: Text('Send'))
          ],
        ),
        Expanded(
          child: FutureBuilder<List<Chat>>(
            // Update to FutureBuilder<List<Ride>>
            future: futureRideChats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
                //} else if (snapshot.hasError) {
                //return Text('Error: ${snapshot.error}');
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
                return const Text('No messages');
              }
            },
          ),
        ),
      ]),
    );
  }
}
