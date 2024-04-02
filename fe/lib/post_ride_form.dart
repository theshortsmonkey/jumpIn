import 'package:flutter/material.dart';
import 'classes/post_ride_class.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:geocode/geocode.dart';
import 'dart:async';
import 'api.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';


class PostRideForm extends StatefulWidget {
  const PostRideForm({super.key});

  @override
  State<PostRideForm> createState() => _PostRideFormState();
}

class _PostRideFormState extends State<PostRideForm> {
  final _startPointTextController = TextEditingController();
  final _startRegionTextController = TextEditingController();
  final _endPointTextController = TextEditingController();
  final _endRegionTextController = TextEditingController();
  final _inputPriceTextController = TextEditingController();
  dynamic? _calculatedPrice; //in pence - to store calc'd result
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedSeats;

  double _formProgress = 0;

  void _showTestScreen() {
    final rideData = RideData(
      startPoint: _startPointTextController.text,
      startRegion: _startRegionTextController.text,
      endPoint: _endPointTextController.text,
      endRegion: _endRegionTextController.text,
      date: _selectedDay,
      seatsAvailable: _selectedSeats,
      price: _inputPriceTextController.text,
    );
    Navigator.of(context).pushNamed('/singleridetest', arguments: rideData);
  }

  Future calculatePrice() async {
  GeoCode geoCode = GeoCode();
  List<Future<Coordinates>> futures = [
    geoCode.forwardGeocoding(address: _startPointTextController.text),
    geoCode.forwardGeocoding(address: _endPointTextController.text),
  ];

  try {
    List<Coordinates> results = await Future.wait(futures);
    // Handle the results of all completed futures
    final double? startLat = results[0].latitude;
    final double? startLong = results[0].longitude; 
    final double? endLat = results[1].latitude;
    final double? endLong = results[1].longitude;

    final String apiString = "lonlat:${startLong},${startLat}|lonlat:${endLong},${endLat}";

    final dynamic geoapifyResponse = await fetchDistance(apiString);
    print(geoapifyResponse.runtimeType);
  } catch (error) {
    // Handle errors if any of the futures fail
    print('Error occurred: $error');
  }
  }



    // setState((){
    //   _calculatedPrice = price;
    // });
  

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _startPointTextController,
      _endPointTextController,
      _inputPriceTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress, // NEW
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), // NEW
          Text('Post a Ride',
              style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _startPointTextController,
              decoration: const InputDecoration(hintText: 'Start point'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _startRegionTextController,
              decoration:
                  const InputDecoration(hintText: 'Select start region'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _endPointTextController,
              decoration: const InputDecoration(hintText: 'End point'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _endRegionTextController,
              decoration: const InputDecoration(hintText: 'Select end region'),
            ),
          ),
          ElevatedButton(onPressed: () { calculatePrice(); }, child: Text('Calculate price')),
          Text('Select your date below'),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton(
              hint: Text('Select available seats'),
              isExpanded: true,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedSeats = newValue;
                  print(_selectedSeats);
                });
              },
              items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('${value}'),
                );
              }).toList(),
            ),
          ),
          Text('We recommend a price of £X'),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _inputPriceTextController,
              decoration: const InputDecoration(hintText: 'Price'),
            ),
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
            onPressed: _formProgress == 1 ? _showTestScreen : null, // UPDATED
            child: const Text('Create Ride'),
          ),
        ],
      ),
    );
  }
}
//DROP DOWN BUTTO

//ANIMATION
class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
