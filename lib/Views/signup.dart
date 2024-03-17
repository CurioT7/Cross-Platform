import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signup_email.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  _buildTermsAndConditionsCheckbox(),
                  _buildSignupButton(
                      "Continue with Google", FontAwesomeIcons.google, context),
                  _buildSignupButton("Continue with Email",
                      FontAwesomeIcons.envelope, context),
                  _buildLoginPrompt(),
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
        SizedBox(height: 20),
        Text(
          "Create an Account to continue",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  Widget _buildTermsAndConditionsCheckbox() {
    return Column(
      children: <Widget>[
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
                    child: Text(
                      'Dummy agreement text',
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
          child: RichText(
            text: TextSpan(
              text: 'User ',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Agreement',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Privacy Policy',
                  ),
                  content: const SingleChildScrollView(
                    child: Text(
                      'Dummy privacy policy text',
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
          child: RichText(
            text: TextSpan(
              text: 'Acknowledged that you understand the ',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _termsAndConditionsAccepted,
              onChanged: (bool? value) {
                setState(() {
                  _termsAndConditionsAccepted = value!;
                });
              },
            ),
            const Text(
              "I agree to the terms and conditions",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
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
        onPressed:  termsAccepted
            ? () async {
          if (text == "Continue with Google") {
            final String url = await _googleSignInService.handleSignIn();
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
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
  final GoogleAuthApi _googleAuthApi = GoogleAuthApi();

  Future<String> handleSignIn() async {
    try {
      print('Initiating Google Authentication...');
      final String url = await _googleAuthApi.initiateGoogleAuth();
      return url;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> handleGoogleAuthCallback(String code) async {
    try {
      print('Handling callback...');
      final String accessToken = await _googleAuthApi.handleGoogleAuthCallback(code);
      print('Extracted Access Token: $accessToken');
      print('Storing Access Token...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      print('Access Token stored.');
    } catch (error) {
      print(error);
    }
  }
}