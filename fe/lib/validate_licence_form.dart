import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import 'classes/get_user_class.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class ValidateLicenceForm extends StatefulWidget {
  final String submitType;
  const ValidateLicenceForm({super.key, required this.submitType});

  @override
  State<ValidateLicenceForm> createState() => _ValidateLicenceFormState();
}

class _ValidateLicenceFormState extends State<ValidateLicenceForm> {
  var _licenceNumberController = TextEditingController(text: '');
  var _codeController = TextEditingController(text: '');
  @override
  void initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _licenceNumberController = TextEditingController();
    _codeController = TextEditingController();
    setState(() {});
    });
  }

  bool _isCodeValid = true;
  bool _isLicenceValid = true;
  double _formProgress = 0;

  void _showWelcomeScreen() async {
    final provider = Provider.of<AuthState>(context, listen:false);
    final currUser = provider.userInfo;
    final userData = User(
      firstName: currUser.firstName,
      lastName: currUser.lastName,
      username: currUser.username,
      email: currUser.email,
      password: currUser.password,
      phoneNumber: currUser.phoneNumber,
      bio: currUser.bio,
      identity_verification_status: true,
      driver_verification_status: currUser.driver_verification_status,
      car:currUser.car
    );
    if (widget.submitType == 'post') {
    final postedUser = await postUser(userData);
    final futureUser = fetchUserByUsername(postedUser.username);
    futureUser.then((user) {
      context.read<AuthState>().setUser(user);
      Navigator.of(context).pushNamed('/');
    });
    } else {
      final patchedUser = await patchUser(userData);
      final futureUser = fetchUserByUsername(patchedUser.username);
      futureUser.then((user) {
        context.read<AuthState>().setUser(user);
        Navigator.of(context).pushNamed('/profile');
      });      
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _licenceNumberController,
      _codeController
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
    String titleText = 'Validate Licence';
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), 
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _licenceNumberController,
              decoration: InputDecoration(
                labelText: 'Licence Number',
                errorText: _isLicenceValid ? null : 'Enter a valid UK licence number', 
                ),
              onChanged: (value) {
                final RegExp regex = RegExp(r'[A-Z0-9]{5}\d[0156]\d([0][1-9]|[12]\d|3[01])\d[A-Z0-9]{3}[A-Z]{2}');
                setState(() {
                  _isLicenceValid = regex.hasMatch(value);
                });
              },
            ),
          ),
            Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Verification code',
                errorText: _isCodeValid ? null : 'Enter a valid verification code', 
                ),
                onChanged: (value) {
                final RegExp regex = RegExp(r'[a-zA-Z0-9]{1,8}');
                setState(() {
                  _isCodeValid = regex.hasMatch(value);
                });
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
            _formProgress > 0.99 ? _showWelcomeScreen : null,
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