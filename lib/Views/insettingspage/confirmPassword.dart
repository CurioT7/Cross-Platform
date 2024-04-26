import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPasswordPage extends StatefulWidget {
  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _validateAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String password = _passwordController.text.trim();

    if (!_isValidPassword(password)) {
      _showSnackBar('Password should be at least 8 characters.');
      return;
    }

    if (token == null) {
      _showSnackBar('Token is null. Please log in again.');
      return;
    }

    // Call the disconnectWithGoogle method from ApiServiceMahmoud
    try {
      final Map<String, dynamic> result =
          await ApiServiceMahmoud().disconnectWithGoogle(password, token);

      if (result['success']) {
        _showSnackBar('Google account disconnected successfully');
      } else {
        _showSnackBar(result['message']);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  bool _isValidPassword(String password) {
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
        title: Text('Confirm Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSubBar(),
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
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
