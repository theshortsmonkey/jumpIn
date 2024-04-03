import 'package:fe/classes/get_user_login.dart';
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
  final _carRegTextController = TextEditingController();
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
  
  Future calculatePrice(carReg) async {
  GeoCode geoCode = GeoCode();

  final startPointFuture = geoCode.forwardGeocoding(address: _startPointTextController.text);
  final endPointFuture = geoCode.forwardGeocoding(address: _endPointTextController.text);
  final carDetailsFuture = fetchCarDetails(carReg);

  return Future.wait([startPointFuture, endPointFuture, carDetailsFuture])
    .then((results) {
      final startPoint = results[0];
      final endPoint = results[1];
      final carDetails = results[2];

      if (carDetails == null){
        throw Exception('Car details not found');
      }

      final fuelType = carDetails["fuelType"];
      final co2 = carDetails["co2Emissions"]; // emissions in g/km
      final fuelPriceFuture = fetchFuelPrice(fuelType);
      print(fuelType);

      // Handle the results of all completed futures
      final double? startLat = startPoint.latitude;
      final double? startLong = startPoint.longitude; 
      final double? endLat = endPoint.latitude;
      final double? endLong = endPoint.longitude;

      final String apiString = "lonlat:${startLong},${startLat}|lonlat:${endLong},${endLat}";
      final String apiString = "lonlat:${startLong},${startLat}|lonlat:${endLong},${endLat}";

      final metreDistanceFuture = fetchDistance(apiString);

      return Future.wait([Future.value(fuelType), Future.value(co2), fuelPriceFuture, metreDistanceFuture])
        .then((results){
          final fuelType = results[0];
          final co2 = results[1];
          final fuelPrice = results[2];
          final metreDistance = results[3];
          final double fuelEfficiency;
          final double journeyPrice;
        
          if(fuelType == 'PETROL'){
            //use co2 to calc mpg and hence cost - petrol: 2310g/L; diesel: 2680g/L
            fuelEfficiency = (2310/co2); //in km/L 
            journeyPrice = (metreDistance/(1000*fuelEfficiency)) * fuelPrice;
          } else { //DIESEL
            fuelEfficiency = (2680/co2); //in km/L 
            journeyPrice = (metreDistance/(1000*fuelEfficiency)) * fuelPrice;
          }

          print(journeyPrice);
        });
      });
  }


    

    
    

  // Future calculatePrice(carReg) async {
  // GeoCode geoCode = GeoCode();

  // final startPointFuture = geoCode.forwardGeocoding(address: _startPointTextController.text);
  // final endPointFuture = geoCode.forwardGeocoding(address: _endPointTextController.text);
  // final carDetailsFuture = fetchCarDetails(carReg);

  // try {
  //   final List results = await Future.wait([startPointFuture, endPointFuture, carDetailsFuture]);
    
  //   final startPoint = results[0];
  //   final endPoint = results[1];
  //   final carDetails = results[2];

  //   final fuelType = carDetails["fuelType"];
  //   final co2 = carDetails["co2Emissions"]; //emissions in g/km
  //   final fuelPrice = await fetchFuelPrice(fuelType);
    
  //   // Handle the results of all completed futures
  //   final double? startLat = startPoint.latitude;
  //   final double? startLong = startPoint.longitude; 
  //   final double? endLat = endPoint.latitude;
  //   final double? endLong = endPoint.longitude;

  //   final String apiString = "lonlat:${startLong},${startLat}|lonlat:${endLong},${endLat}";

  //   final dynamic metreDistance = await fetchDistance(apiString);
  //   final fuelEfficiency;
  //   final double journeyPrice;

  //   if(fuelType == 'PETROL'){
  //     //use co2 to calc mpg and hence cost - petrol: 2310g/L; diesel: 2680g/L
  //     fuelEfficiency = (2310/co2); //in km/L 
  //     journeyPrice = (metreDistance/(1000*fuelEfficiency)) * fuelPrice;
  //   } else { //DIESEL
  //     fuelEfficiency = (2680/co2); //in km/L 
  //     journeyPrice = (metreDistance/(1000*fuelEfficiency)) * fuelPrice;
  //   }
  //   print(journeyPrice);
  // } catch (error) {
  //   // Handle errors if any of the futures fail
  //   print('Error occurred: $error');
  // }
  // }



    // setState((){
    //   _calculatedPrice = price;
    // });
  

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _startPointTextController,
      _endPointTextController,
      _inputPriceTextController,
      _inputRegTextController,
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
    final userData = context.read<AuthState>().userInfo;
    //if user has a car return form, if not present message - need to have car and licence validated to post ride
    // print(userData.car['reg']);

    if (userData.car['reg'] != null) {
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _carRegTextController,
              decoration: const InputDecoration(hintText: 'Enter Car Reg'),
            ),
          ),
          ElevatedButton(onPressed: () { calculatePrice(_carRegTextController.text); }, child: Text('Calculate price')),
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

    } else {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: const Text('jumpIn')
      ),
      body: const Center(
        child: Text(
        'You need to have a car to post a ride.',
        style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
    }
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
