import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final chat;
  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final titleStyleL = theme.textTheme.titleLarge;
    final titleStyleM = theme.textTheme.titleMedium;
    final titleStyleS = theme.textTheme.titleSmall;
    return GestureDetector(
      onTap: () {
        //enable action upon tapping the card
        Navigator.of(context).pushNamed('/ridechat', arguments: chat.id);
      },
      child: Card(
        // Define the shape of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Add an image widget to display an image
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/user.JPG'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${chat.message}',
                        style: titleStyleM,
                      ),
                    ],
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 20),
                  // Add an expanded widget to take up the remaining horizontal space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add some spacing between the top of the card and the title
                        Container(height: 5),
                        // Add a title widget
                        Text("${chat.from}", style: titleStyleM),
                        const Icon(Icons.arrow_circle_down_rounded),
                        // Add a subtitle widget
                        Text("${chat.to}", style: titleStyleM),
                        // Add some spacing between the subtitle and the text
                        Container(height: 10),
                        // Add a text widget to display some text
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
