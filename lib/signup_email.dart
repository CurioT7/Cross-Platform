import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:animate_do/animate_do.dart';

class SignUpWithEmail extends StatefulWidget {
  @override
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  final ValueNotifier<bool> rotateNotifier = ValueNotifier<bool>(false);
  bool _passwordVisible = false;

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
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50.0,
                      child: Image.asset('images/signup.jpg'),
                    ),
                    CustomTextField('UserName', _usernameController),
                    const SizedBox(height: 20),
                    CustomTextField('Email', _emailController),
                    const SizedBox(height: 20),
                    CustomTextField(
                      'Password',
                      _passwordController,
                      obscureText: !_passwordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    LoginButton(_formKey, _usernameController, _emailController,
                        _passwordController, _apiService),
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

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField(
    this.labelText,
    this.controller, {
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (labelText == 'Email') {
          // Check if the email is in the correct format
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern.toString());
          if (!regex.hasMatch(value!))
            return 'Enter a valid email';
          else
            return null;
        } else if (labelText == 'Password') {
          // Check if the password length is greater than 8
          if (value!.length < 8)
            return 'Password must be longer than 8 characters';
          else
            return null;
        }
        return null;
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ApiService apiService;

  const LoginButton(this.formKey, this.usernameController, this.emailController,
      this.passwordController, this.apiService);

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
            print('Username: ${usernameController.text}');
            final isRegistered =
                await apiService.isUsernameAvailable(usernameController.text);
            if (isRegistered['success'] == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Username is already taken'),
                ),
              );
            } else {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                print('Username: ${usernameController.text}');
                print('Email: ${emailController.text}');
                print('Password: ${passwordController.text}');
                await apiService.signup(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                );
                Navigator.pop(context);
              }
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
