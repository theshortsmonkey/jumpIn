import 'package:flutter/material.dart';
import 'classes/post_ride_class.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:geocoding/geocoding.dart';

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
  int? _calculatedPrice; //in pence - to store calc'd result
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

  Future<int> calculatePrice() async {
    final startPoint = _startPointTextController.text;
    final endPoint = _endPointTextController.text;
    print(startPoint);
    print(endPoint);
    var price;
    List<Location> locationStart = await locationFromAddress(startPoint);
    List<Location> locationEnd = await locationFromAddress(endPoint);

    setState((){
      _calculatedPrice = price;
    });
  }

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
          ElevatedButton(onPressed: () {}, child: Text('Calculate price')),
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
