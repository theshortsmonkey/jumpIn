import 'package:flutter/material.dart';

class RideCard extends StatelessWidget {
  final ride;
  const RideCard({
    super.key,
    required this.ride
  });

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final textStyle = theme.textTheme.bodyMedium;
  final titleStyleL = theme.textTheme.titleLarge;
  final titleStyleM = theme.textTheme.titleMedium;
  final titleStyleS = theme.textTheme.titleSmall;
  final String imgURL = 'http://localhost:1337/users/${ride?.driverUsername}/image';
  return GestureDetector(
    onTap: () {
      //enable action upon tapping the card
      Navigator.of(context).pushNamed('/singleridetest', arguments: ride.id);
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
              Column(children: [
                new CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imgURL),
              ),
              SizedBox(height: 10),
              Text(
                '${ride.driverUsername}',
                style: titleStyleM,
              ),
              ],),
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
                    Text(
                      "${ride.from}",
                      style: titleStyleM
                      ),
                    Icon(Icons.arrow_circle_down_rounded),
                    // Add a subtitle widget
                    Text(
                    "${ride.to}",
                    style: titleStyleM
                    ),
                    // Add some spacing between the subtitle and the text
                    Container(height: 10),
                    // Add a text widget to display some text
                    Text(
                      "Date ${ride.dateTime.substring(0,10)}",
                      style: titleStyleS
                    ),
                    Text(
                      "Time ${ride.dateTime.substring(11,16)}",
                      style: titleStyleS
                    )
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