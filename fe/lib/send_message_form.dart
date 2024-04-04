import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class SendMessageForm extends StatefulWidget {
  final String submitType;
  const SendMessageForm({super.key, required this.submitType});

  @override
  State<SendMessageForm> createState() => _SendMessageFormState();
}

class _SendMessageFormState extends State<SendMessageForm> {
  var _message = TextEditingController(text: '');
  @override
  void initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    final provider = Provider.of<AuthState>(context, listen:false);
    final currUser = provider.userInfo;
    _message = TextEditingController(text: currUser.bio);
    setState(() {});
    });
  }
void _showRideChatScreen() async {
    final messageData = Message(
      message: _message.text,
      
    );
    if (widget.submitType == 'post') {
    final postedMessage = await postMessage(messageData);
    final futureMessage = fetchMessagesByRideId(postedMessage.id);
    futureMessage.then((message) {
      context.read<AuthState>().setMessage(message);
      Navigator.of(context).pushNamed('/');
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText;
    widget.submitType == 'post' 
    ? titleText = 'Send message';
  
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), 
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _messageTextController,
              decoration: InputDecoration(
                labelText: 'Message',
                errorMaxLines: 3,
                errorText: _isMessageNameValid ? null : 'Enter valid message: cannot be empty'
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
            onPressed:
            _formProgress > 0.99 ? _showRideChatScreen : null,
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