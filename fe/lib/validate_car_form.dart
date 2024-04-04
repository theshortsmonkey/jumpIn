import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import 'classes/get_user_class.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class ValidateCarFrom extends StatefulWidget {
  final String submitType;
  const ValidateCarFrom({super.key, required this.submitType});

  @override
  State<ValidateCarFrom> createState() => _ValidateCarFormState();
}

class _ValidateCarFormState extends State<ValidateCarFrom> {
  var _regNumberController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _regNumberController = TextEditingController();
    });
  }

  double _formProgress = 0;

  void _validateVehicleDetails() async {
    var regNumber = _regNumberController.text;
    final provider = Provider.of<AuthState>(context, listen: false);
    final currUser = provider.userInfo;
    dynamic carData;
    await fetchCarDetails(regNumber).then((res) {
      carData = res;
    });
    if (carData["taxStatus"] == "Taxed") {
      final carDetails = {
        "make":carData["make"],
        "reg":carData["registrationNumber"],
        "colour":carData["colour"],
        "tax_due_date":carData["taxDueDate"],
        "fuel_type":carData["fuelType"],
        "co2_emissions":carData["co2Emissions"]
      };
    var userData = User(
      firstName: currUser.firstName,
      lastName: currUser.lastName,
      username: currUser.username,
      email: currUser.email,
      password: currUser.password,
      phoneNumber: currUser.phoneNumber,
      bio: currUser.bio,
      identity_verification_status: currUser.identity_verification_status,
      driver_verification_status: true,
      car : carDetails
    );
      final patchedUser = await patchUser(userData);
      final futureUser = fetchUserByUsername(patchedUser.username);
      futureUser.then((user) {
        context.read<AuthState>().setUser(user);
        Navigator.of(context).pushNamed('/profile');
      });
    } else {
      Navigator.of(context).pushNamed('/');
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _regNumberController,
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
    String titleText = 'Validate Car';
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _regNumberController,
              decoration: const InputDecoration(
                labelText: 'Reg Number',
              ),
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
            onPressed: _formProgress > 0.99 ? _validateVehicleDetails : null,
            child: Text(titleText),
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
