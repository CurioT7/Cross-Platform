import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/views/signIn/forgotPassword.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart ';
import 'package:shared_preferences/shared_preferences.dart ';

class UpdateEmailAdressPage extends StatefulWidget {
  @override
  State<UpdateEmailAdressPage> createState() => _UpdateEmailAdressPageState();
}

class _UpdateEmailAdressPageState extends State<UpdateEmailAdressPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  void _validateAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String newEmail = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (!_isValidEmail(newEmail)) {
      _showSnackBar('Please enter a valid email address.');
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnackBar('Password should be at least 8 characters.');
      return;
    }

    if (token == null) {
      _showSnackBar('Token is null. Please log in again.');
      return;
    }
    print(
        'the new email is $newEmail,and the pssword is $password ,token $token');
    final Map<String, dynamic> result =
        await ApiServiceMahmoud().changeEmail(newEmail, password, token);

    if (result['success']) {
      _showSnackBar('Email updated successfully');
      Navigator.of(context).pop();
    } else {
      _showSnackBar(result['message']);
    }
  }

  bool _isValidEmail(String email) {
    // Validation logic for email format
    // You can use regex or other validation methods
    return email.contains('@') && email.contains('.com');
  }

  bool _isValidPassword(String password) {
    // Validation logic for password
    return password.length >= 8;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSubBar(),
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
                labelText: 'Password',
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
            ElevatedButton(
              onPressed: _validateAndSave,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
