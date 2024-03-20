import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/Views/signIn/signIn.dart';
import 'package:curio/Views/signUp/userName.dart';
import 'package:url_launcher/url_launcher.dart';


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
  final GoogleAuthSignInService googleAuthSignInService = GoogleAuthSignInService();
  bool validEmail = false;
  bool validPassword = false;

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: redditBackgroundWhite,
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/Curio.png',
                    fit: BoxFit.contain,
                    height: 60,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // navigate to sign in page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: const Text('Login ', style: TextStyle(color: redditGrey)),
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
                    onPressed: () async{
                      String dummy = 'http://192.168.1.2:3000/api/auth/google';

                      if (await canLaunch(dummy)) {
                        await launch(dummy);
                      } else {
                        throw 'Could not launch $dummy';
                      }
                      // request to the server token??

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

  const LoginButton(
      this.formKey, this.emailController, this.passwordController,
      {this.validInput = false, super.key});

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
          onPressed:() async {
           // check for the eamil if exist
            // ApiService apiService = ApiService();
            // var response = await apiService.checkEmail(emailController.text);
            // if (response.statusCode == 200) {
            //   print('Email already exist');
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text('Email already exist'),
            //       duration: Duration(seconds: 2),
            //     ),
            //   );
            // }
            print('Email: ${emailController.text}');
            print('Password: ${passwordController.text}');
            Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context) => CreateUsernamePage(email: emailController.text, password: passwordController.text),
                ),
              );
          },
          color: redditOrange,
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