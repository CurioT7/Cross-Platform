import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'userName.dart';
import 'package:flutter_application_1/services/auth_services.dart';

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
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigate to login page
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
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50.0,
                      child: Image.asset('images/signup.jpg'),
                    ),
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

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;

  const CustomTextField(
      this.labelText,
      this.controller, {
        this.obscureText = false,
        this.onChanged,
      });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? _isValid;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {
          if (widget.labelText == 'Email') {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern.toString());
            _isValid = regex.hasMatch(value);
          } else if (widget.labelText == 'Password') {
            _isValid = value.length >= 8;
          }
        });
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: _isValid == null
            ? null
            : _isValid!
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.error, color: Colors.red),
      ),
      obscureText: widget.obscureText,
      validator: (value) {
        if (widget.labelText == 'Email') {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern.toString());
          if (!regex.hasMatch(value!))
            return 'Enter a valid email';
          else
            return null;
        } else if (widget.labelText == 'Password') {
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
              // -DEBUG: await apiService.signup(emailController.text, passwordController.text);
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