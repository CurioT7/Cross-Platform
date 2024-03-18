import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/Views/signIn/forgot_password_page.dart';
import 'package:curio/Views/signUp/signup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                // navigate to sign up page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(),
                  ),
                );
              },
              child: const Text('Sign Up', style: TextStyle(color: redditGrey)),
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
                  Text(
                      'Log In to Curio',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), 
                    ),
                  const SizedBox(height: 20), 
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {},
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
                            child: Image.asset('lib/assets/images/google.png', height: 30, width: 30),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text('Continue with Google', style: TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("  OR  ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                      ),
                      Expanded(child: Divider(color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField('Email', _emailController),
                  const SizedBox(height: 20),
                  CustomTextField(
                    'Password',
                    _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: redditOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
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
            SizedBox(height: 20),
            LoginButton(_formKey, _emailController, _passwordController),
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

  const LoginButton(
      this.formKey, this.emailController, this.passwordController);

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
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              print('Email: ${emailController.text}');
              print('Password: ${passwordController.text}');
              print('Signing up...');
              // -DEBUG: await apiService.isEmailAvailable(emailController.text);
              // -TODO: save the email and password to be passed to the next page
              print('Signup successful');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }
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