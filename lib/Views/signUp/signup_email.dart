import 'package:curio/Views/Home_screen.dart';
import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/Views/signIn/signIn.dart';
import 'package:curio/Views/signUp/userName.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({super.key});

  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignUpWithEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final GoogleAuthSignInService googleAuthSignInService =
      GoogleAuthSignInService();
  bool validEmail = false;
  bool validPassword = false;
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: redditBackgroundWhite,
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
        elevation: 0,
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
                  // navigate to sign in page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(),
                    ),
                  );
                },
                child:
                    const Text('Login ', style: TextStyle(color: redditGrey)),

              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Text(
                    ' Hi new Friend!, Welcome to Curio',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      // sign in with google
                      UserCredential? userCredential =
                          await googleAuthSignInService.signInWithGoogle();
                      if (userCredential != null) {
                        String? accessToken =
                            userCredential.credential?.accessToken;
                        await apiService.signInWithToken(accessToken!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        // stay on the same page
                      }
                    },
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                    height: 50,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Image.asset('lib/assets/images/google.png',
                                height: 30, width: 30),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('Continue with Google',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("  OR  ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      Expanded(child: Divider(color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField('Email', _emailController,
                      onValidChanged: (isValid) {
                    setState(() {
                      validEmail = isValid;
                    });
                  }),
                  const SizedBox(height: 20),
                  CustomTextField(
                    'Password',
                    _passwordController,
                    obscureText: true,
                    onValidChanged: (isValid) {
                      setState(() {
                        validPassword = isValid;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "By continuing, you agree to Curio's Terms of Service and Privacy Policy.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LoginButton(_formKey, _emailController, _passwordController,
                validInput: validEmail && validPassword),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool validInput;

  const LoginButton(this.formKey, this.emailController, this.passwordController,
      {this.validInput = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: validInput
              ? () async {
                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateUsernamePage(
                          email: emailController.text,
                          password: passwordController.text),
                    ),
                  );
                }
              : null, // Disable the button if the inputs are not valid
          color: validInput
              ? redditOrange
              : Colors
                  .grey, // Change the color based on whether the input is valid
          disabledColor: Colors.grey, // Set the color of the disabled button
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: redditBackgroundWhite,
            ),
          ),
        ),
      ),
    );
  }
}
