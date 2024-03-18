import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'userName.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/Views/signIn/sign_in_page.dart';


class SignUpWithEmail extends StatefulWidget {
  @override
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
        title: Image.asset(
          'lib/assets/images/Curio.png',
          fit: BoxFit.contain,
          height: 60,
        ),
        centerTitle:
        true, // This ensures that the title is in the center of the AppBar
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ),
              );
            },
            child: const Text(
              "Log in",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Center(
            child: FadeInUp(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomTextField('Email', _emailController),
                    const SizedBox(height: 20),
                    CustomTextField(
                      'Password',
                      _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 50),
                    LoginButton(_formKey,_emailController,
                        _passwordController),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton(this.formKey, this.emailController, this.passwordController);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black),
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
                  builder: (context) => CreateUsernamePage(),
                ),
              );
            }
          },
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Text(
            'Create',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}