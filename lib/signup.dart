import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signup_email.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _termsAndConditionsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FadeInUp(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50.0,
                    child: Image.asset('images/signup.jpg'),
                  ),
                  _buildIntroText(),
                  _buildSignupButton(
                      "Continue with Google", FontAwesomeIcons.google, context),
                  _buildSignupButton("Continue with Email",
                      FontAwesomeIcons.envelope, context),
                  _buildLoginPrompt(),
                  _buildTermsAndConditionsCheckbox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: const <Widget>[
        Text(
          "Sign up",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Welcome to Reddit, the front page of the internet.",
          style: TextStyle(
            fontSize: 17,
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

Widget _buildSignupButton(String text, IconData icon, BuildContext context) {
  return SignupButton(
    text: text,
    icon: icon,
    termsAccepted: _termsAndConditionsAccepted,
  );
}

  Widget _buildTermsAndConditionsCheckbox() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _termsAndConditionsAccepted,
          onChanged: (bool? value) {
            setState(() {
              _termsAndConditionsAccepted = value!;
            });
          },
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Terms and Conditions',
                  ),
                  content: const SingleChildScrollView(
                    // pulled points to the left
                    child: Text(
                      'By signing up, you agree to not take the last slice of pizza without asking. You also agree to laugh at our jokes, even the bad ones. Remember, a day without laughter is a day wasted!',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Text(
            "I agree to the terms and conditions",
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Already a redditor? ",
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpWithEmail()));
          },
          child: const Text(
            "Log in",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}



class SignupButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool termsAccepted;
  final GoogleAuthSignInService _googleSignInService;

  SignupButton({
    required this.text,
    required this.icon,
    this.onPressed,
    required this.termsAccepted,
  }) : _googleSignInService = GoogleAuthSignInService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: termsAccepted
            ? () {
                if (text == "Continue with Google") {
                  _googleSignInService.handleSignIn(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpWithEmail(),
                    ),
                  );
                }
              }
            : null,
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class GoogleAuthSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final GoogleAuthApi _googleAuthApi = GoogleAuthApi();

  Future<void> handleSignIn(BuildContext context) async {
    try {
      print('Initiating Google Authentication...');
      await _googleAuthApi.initiateGoogleAuth();
      print('Redirecting to Google...');
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      print('Handling callback...');
      final GoogleSignInAuthentication googleAuth = await account!.authentication;
      print('Extracted Access Token: ${googleAuth.accessToken}');
      print('Storing Access Token...');
      final String accessToken = await _googleAuthApi.handleGoogleAuthCallback();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      print('Redirecting to home page...');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpWithEmail(),
        ),
      );
    } catch (error) {
      print(error);
    }
  }
}
