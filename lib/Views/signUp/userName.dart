import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/api_service.dart';

class CreateUsernamePage extends StatefulWidget {
  final String email;
  final String password;
  const CreateUsernamePage({Key? key, required this.email, required this.password}) : super(key: key);
  @override
  _CreateUsernamePageState createState() => _CreateUsernamePageState();
}
class _CreateUsernamePageState extends State<CreateUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool? _isUsernameAvailable;
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  // const SizedBox(height: 20), // Add a SizedBox widget for padding
                  const Text(
                    'Most Curious? Create a unique username to get started!',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Add a SizedBox widget for padding
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextField('Username', _usernameController, onValidChanged: (isValid) {
                          // check if the usrename is available through api
                          apiService.isUsernameAvailable(_usernameController.text).then((isUsernameAvailable) {
                            setState(() {
                              _isUsernameAvailable = isUsernameAvailable['success'];
                            });
                          });
                        }),
                        const SizedBox(height: 20), // Add a SizedBox widget for padding
                        ElevatedButton(
                          onPressed: _isUsernameAvailable == true ? _continue : null,
                          child: const Text('Continue'),
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
  void _continue() async { // Make the method asynchronous
    if (_formKey.currentState!.validate()) {
      var response = await apiService.signup(widget.email, widget.password, _usernameController.text); // Call the signup method of the apiService
      if (response['success'] == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        print('Signup failed');
        // Show error message
      }
    }
  }
}