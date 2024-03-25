import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateUsernamePage extends StatefulWidget {
  final String email;
  final String password;
  final String? token;

  const CreateUsernamePage({Key? key, required this.email, required this.password, this.token}) : super(key: key);
  @override
  _CreateUsernamePageState createState() => _CreateUsernamePageState();
  }

class _CreateUsernamePageState extends State<CreateUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool? _isUsernameAvailable;
  final ApiService apiService = ApiService();
  final FlutterSecureStorage storage = FlutterSecureStorage(); // Declare storage here

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
                  const SizedBox(height: 20),
                  // Add a SizedBox widget for padding
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextField('Username', _usernameController,
                            onValidChanged: (isValid) {
                              // check if the usrename is available through api
                              apiService.isUsernameAvailable(
                                  _usernameController.text).then((
                                  isUsernameAvailable) {
                                setState(() {
                                  _isUsernameAvailable =
                                  isUsernameAvailable['success'];
                                });
                              });
                            }),
                        const SizedBox(height: 20),
                        // Add a SizedBox widget for padding
                        ElevatedButton(
                          onPressed: _isUsernameAvailable == true
                              ? _continue
                              : null,
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

  void _continue() async {
    // Make the method asynchronous
    if (_formKey.currentState!.validate()) {
      var response;
      if (widget.token != null) {
        response = await apiService.signInWithToken(
            widget.token!);
      } else {
        response = await apiService.signup(
            _usernameController.text, widget.email, widget.password);
      }
      if (response['success'] && response['accessToken'] != null) {
       // this is a session storage?
        // storage save per session or per device? ans: per device change it to session
        await storage.write(key: 'token', value: response['accessToken']);
        Navigator.of(context).pushReplacement(
          // load the token to the home screen
            MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print(response['message']);
      }
    }
  }
}