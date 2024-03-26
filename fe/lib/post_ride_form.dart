import 'package:flutter/material.dart';
import './ride_data.dart';
import 'package:table_calendar/table_calendar.dart';




class PostRideForm extends StatefulWidget {
  const PostRideForm({super.key});

  @override
  State<PostRideForm> createState() => _PostRideFormState();
}

class _PostRideFormState extends State<PostRideForm> {
  final _startPointTextController = TextEditingController();
  final _endPointTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; 



  double _formProgress = 0;

  void _showTestScreen() {
    final rideData = RideData(
      startPoint: _startPointTextController.text,
      endPoint: _endPointTextController.text,
      price: _priceTextController.text,
      date: _selectedDay,
    );
    Navigator.of(context).pushNamed('/test', arguments: rideData);
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _startPointTextController,
      _endPointTextController,
      _priceTextController,
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
          Text('Post a Ride', style: Theme.of(context).textTheme.headlineMedium),
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
              controller: _endPointTextController,
              decoration: const InputDecoration(hintText: 'End poing'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _priceTextController,
              decoration: const InputDecoration(hintText: 'Price'),
            ),
          ),
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
            onPressed:
            _formProgress == 1 ? _showTestScreen : null, // UPDATED
            child: const Text('Create Ride'),
          ),
        ],
      ),
    );
  }
}

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