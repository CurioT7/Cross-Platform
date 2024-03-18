import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curio/services/auth_services.dart';
import 'dart:convert';
import 'package:curio/services/mock_api_service.dart';
import 'Home_screen.dart';
import 'reddit_colors.dart';
import 'forgot_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MockApiService _apiService = MockApiService();
  bool _obscureText = true; // Add a boolean variable to control the visibility

  // void _signIn() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     final response = await _apiService.signIn(_email, _password);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       debugPrint('Signed in with token: ${data['token']}');
  //     } else {
  //       final data = jsonDecode(response.body);
  //       debugPrint('Sign-in failed: ${data['error']}');
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Sign-in failed: ${data['error']}'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }
void _signInEmail() async {
  String email = _emailController.text;
  String password = _passwordController.text;

  if (email.isEmpty || !email.contains('@')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a valid email.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (password.isEmpty || password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a password of at least 6 characters.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      default:
        message = 'An unknown error occurred.';
        break;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/images/Curio.png',
                fit: BoxFit.contain,
                height: 60,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement sign up
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.grey),), // Changed to only text
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              const Center(child: Text('Log in to Curio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // TODO: Implement sign in with phone number
              //   },
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Icon(Icons.phone),
              //       const SizedBox(width: 10),
              //       const Text('Continue with phone number', style: TextStyle(color: Colors.black),)
              //     ],
              //   ),
              // ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign in with Google
                  AuthService().signInWithGoogle();
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/google.png',
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text('Continue with Google' , style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '    OR    ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email or Username',
                  fillColor: redditGrey,
                  filled: true,
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none, // Set border side to none
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none, // Set border side to none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: Colors.black), // Set border side to a visible color when focused
                ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
                onSaved: (value) => _emailController.text = value!,
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      fillColor: redditGrey,
                      filled: true,
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide.none, // Set border side to none
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide.none, // Set border side to none
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(color: Colors.black), // Set border side to a visible color when focused
                    ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                    onSaved: (value) => _passwordController.text = value!,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Toggle the visibility
                      });
                    },
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // Show different icons based on the visibility state
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Forgot password?' ,style: TextStyle(color: redditOrange), ),
                ),
              ),
              const Text('By continuing, you agree to our User Agreement and acknowledge that you understand the Privacy Policy.', style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redditOrange, // background color
                ),
                onPressed: _signInEmail,
                child: const Text('Continue' , style: TextStyle(color: Colors.white),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}