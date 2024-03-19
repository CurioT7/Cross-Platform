import 'package:flutter/material.dart';
import 'package:curio/utils/component_app_bar.dart';
import 'package:curio/utils/component_user_info_sub_appbar.dart';
import 'package:curio/views/signin/forgot_password_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _isEmailValid = false;
  bool _isNewPasswordValid = false;
  bool _arePasswordsMatching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        title: 'Reset password',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserInfoSubBar(),
            // Current Password
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current password',
                suffix: TextButton(
                  onPressed: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    'Forgot password',
                  ),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),

            // New Password
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _isNewPasswordValid = value.length >= 8; // Validate new password
                });
              },
            ),
            SizedBox(height: 10),

            // Confirm New Password
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(labelText: 'Confirm new password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _arePasswordsMatching = _newPasswordController.text == value; // Check if passwords match
                });
              },
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
                    onPressed: () {
                      // Validate email, new password, and password match
                      _validateAndSave();
                    },
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
      ),
    );
  }

  void _validateAndSave() {
    // Check email format
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_currentPasswordController.text)) {
      // Show invalid email snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Colors.grey,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Invalid email.'),
            ),
          ),
        ),
      );
      return;
    }

    // Check if any of the passwords is less than 8 characters
    if (_newPasswordController.text.length < 8 || _confirmNewPasswordController.text.length < 8) {
      // Show password length snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Colors.grey,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Passwords should be at least 8 characters.'),
            ),
          ),
        ),
      );
      return;
    }

    // If everything is valid, proceed with saving
    // Save logic
    print('Updating email and password...');
    // Show success snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.green,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text('Email and password updated successfully.'),
          ),
        ),
      ),
    );
  }
}
