import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_1/Views/Home_screen.dart';
import 'package:flutter_application_1/utils/helpers.dart';

class CreateUsernamePage extends StatefulWidget {
  @override
  _CreateUsernamePageState createState() => _CreateUsernamePageState();
}
class _CreateUsernamePageState extends State<CreateUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool? _isUsernameAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Username'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FadeInUp(
            child: Center( // Wrap the Column widget with a Center widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'lib/assets/images/Curio.png',
                    fit: BoxFit.contain,
                    height: 60,
                  ),
                  SizedBox(height: 20), // Add a SizedBox widget for padding
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextField('Username', _usernameController),
                        SizedBox(height: 20), // Add a SizedBox widget for padding
                        ElevatedButton(
                          onPressed: _isUsernameAvailable == true ? _continue : null,
                          child: Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _continue() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}