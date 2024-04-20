import 'package:flutter/material.dart';

class JoinButton extends StatefulWidget {
  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  bool _buttonPressed = false;

  void _handlePress() {
    setState(() {
      _buttonPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 30,
      child: _buttonPressed
          ? Icon(Icons.check, color: Color.fromARGB(255, 3, 94, 252))
          :ElevatedButton(
  onPressed: _handlePress,
  child: Text(
    'Join',
    style: TextStyle(fontSize: 11),
  ),
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 3, 94, 252)),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
  ),
),
    );
  }
}