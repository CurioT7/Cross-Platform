import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/views/signin/forgot_password_page.dart';

class UpdateEmailAdressPage extends StatefulWidget {
  @override
  State<UpdateEmailAdressPage> createState() => _UpdateEmailAdressPageState();
}

class _UpdateEmailAdressPageState extends State<UpdateEmailAdressPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _validateAndSave() {
    String newEmail = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Check if the email is valid
    if (!_isValidEmail(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }
    // Check if the password is valid
    if (!_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password should be at least 8 characters.'),
        ),
      );
      return;
    }
    Navigator.of(context).pop();
  }

  bool _isValidEmail(String email) {
    // Regular expression to validate email format
    // This is a basic validation; you may use a more sophisticated approach
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern.toString());
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(title: 'Update Email Address'),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          UserInfoSubBar(),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'New email address',
              hintText: 'Enter new email address',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Reddit Password',
              hintText: 'Enter password',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            ),
            obscureText: _obscureText,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Cancel logic
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: _validateAndSave,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
