import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import 'classes/get_user_class.dart';
import 'package:email_validator/email_validator.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  final String submitType;
  const SignUpForm({super.key, required this.submitType});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var _firstNameTextController = TextEditingController(text: '');
  var _lastNameTextController = TextEditingController(text: '');
  var _usernameTextController = TextEditingController(text: '');
  var _passwordTextController = TextEditingController(text: '');
  var _emailTextController = TextEditingController(text: '');
  var _phoneNumberController = TextEditingController(text: '');
  var _bioController = TextEditingController(text: '');
  @override
  void initState () {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    final provider = Provider.of<AuthState>(context, listen:false);
    final currUser = provider.userInfo;
    _firstNameTextController = TextEditingController(text: currUser.firstName);
    _lastNameTextController = TextEditingController(text: currUser.lastName);
    _usernameTextController = TextEditingController(text: currUser.username);
    _passwordTextController = TextEditingController(text: currUser.password);
    _emailTextController = TextEditingController(text: currUser.email);
    _phoneNumberController = TextEditingController(text: currUser.phoneNumber);
    _bioController = TextEditingController(text: currUser.bio);
    setState(() {});
    });
  }


  bool _isEmailValid = true;
  bool _isPhoneNumberValid = true;
  bool _isUserNameValid = true;
  bool _isPasswordValid = true;
  bool _isPasswordObscured = true;
  double _formProgress = 0;

  void _showWelcomeScreen() async {
    final provider = Provider.of<AuthState>(context, listen:false);
    final currUser = provider.userInfo;
    final userData = User(
      firstName: _firstNameTextController.text,
      lastName: _lastNameTextController.text,
      username: _usernameTextController.text,
      email: _emailTextController.text,
      password: _passwordTextController.text,
      phoneNumber: _phoneNumberController.text,
      bio: _bioController.text,
      identity_verification_status: currUser.identity_verification_status,
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
    String titleText;
    widget.submitType == 'post' 
    ? titleText = 'Sign Up'
    : titleText = 'Edit Profile';
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), 
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(
                labelText: 'Username',
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
              decoration: const InputDecoration(labelText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(labelText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(
                labelText: 'Email',
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
                labelText: 'Phone Number',
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
                labelText: 'Password',
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
              decoration: const InputDecoration(labelText: 'Bio'),
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