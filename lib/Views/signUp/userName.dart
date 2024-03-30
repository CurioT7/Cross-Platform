import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  if (_formKey.currentState!.validate()) {
    UserCredential? userCredential;
    if (widget.token != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', widget.token!);
    } else {
      userCredential = await apiService.signup(widget.email, widget.password);
    }

    if (userCredential != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await userCredential.user!.getIdToken();
      await prefs.setString('token', token!);

      // Navigate to a new screen that waits for email verification
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
      );
    } else {
      print('Signup failed');
    }
  }
}
}
class EmailVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkEmailVerified(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Verifying your email...'));
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.data == true) {
                // If email is verified, navigate to HomeScreen
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                });
              }
              return Center(child: Text('Please verify your email'));
            }
          }
        },
      ),
    );
  }

  Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    return user.emailVerified;
  }
}