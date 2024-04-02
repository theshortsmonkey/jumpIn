import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'classes/get_user_class.dart';
import 'package:email_validator/email_validator.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isEmailValid = true;
  bool _isPhoneNumberValid = true;
  bool _isUserNameValid = true;
  bool _isPasswordValid = true;
  bool _isPasswordObscured = true;
  double _formProgress = 0;

  void _showWelcomeScreen() async {
    final userData = User(
      firstName: _firstNameTextController.text,
      lastName: _lastNameTextController.text,
      username: _usernameTextController.text,
      email: _emailTextController.text,
      password: _passwordTextController.text,
      phoneNumber: _phoneNumberController.text,
      bio: _bioController.text,
    );
    final postedUser = await postUser(userData);
    final futureUser = fetchUserByUsername(postedUser.username);
    futureUser.then((user) {
      context.read<AuthState>().setUser(user);
      Navigator.of(context).pushNamed('/');
    });
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _passwordTextController,
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController,
      _emailTextController,
      _phoneNumberController,
      _bioController
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
  void _setIsPasswordObscured() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), 
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(
                hintText: 'Username',
                errorMaxLines: 3,
                errorText: _isUserNameValid ? null : 'Enter valid username: letters, numbers or underscore. 5-20 characters'
                ),
                onChanged: (value) {
                  final RegExp regex = RegExp(r'^[a-zA-Z0-9_]{5,20}$');
                  setState(() {
                    _isUserNameValid = regex.hasMatch(value);
                  });
                },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(
                hintText: 'Email: joebloggs@example.com',
                errorText: _isEmailValid ? null : 'enter a valid email address', 
                ),
            onChanged: (value) {
              setState(() {
                _isEmailValid = EmailValidator.validate(value);
              });
            }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                errorText: _isPhoneNumberValid ? null : 'enter valid UK phone number'
                ),
              onChanged: (value) {
                final RegExp regex = RegExp(r'^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$');
                setState(() {
                  _isPhoneNumberValid = regex.hasMatch(value);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              obscureText: _isPasswordObscured,
              controller: _passwordTextController,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordObscured ? Icons.visibility : Icons.visibility_off),
                  onPressed:_setIsPasswordObscured,
                ),
                errorMaxLines: 3,
                errorText: _isPasswordValid ? null : "Enter valid password: At least one lowercase letter, one uppercase letter, one digit, one special character '`@!%*?&', at least 8 characters"
                ),
                onChanged: (value) {
                  final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                  setState(() {
                    _isPasswordValid = regex.hasMatch(value);
                  });
                }
            ),
          ),
            Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(hintText: 'Bio'),
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
            child: const Text('Sign up'),
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