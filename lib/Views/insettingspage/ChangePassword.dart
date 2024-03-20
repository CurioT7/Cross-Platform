import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/views/signin/forgotpassword.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';


class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  void _validateAndSave() {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmNewPassword = _confirmNewPasswordController.text.trim();

    // Check if current password is empty or less than 8 characters
    if (currentPassword.isEmpty || currentPassword.length < 8) {
      _showSnackBar('Current password should be at least 8 characters.');
      return;
    }

    // Check if new password is empty or less than 8 characters
    if (newPassword.isEmpty || newPassword.length < 8) {
      _showSnackBar('New password should be at least 8 characters.');
      return;
    }

    // Check if new password and confirm new password match
    if (newPassword != confirmNewPassword) {
      _showSnackBar('New password and confirm password do not match.');
      return;
    }
    _showSnackBar('password updated successfully');
    Navigator.of(context).pop();
    return;




  }

  void _showSnackBar(String message) {
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
            child: Text(message),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        title: 'Reset password',
      ),
      body: SingleChildScrollView( // Wrap your body with SingleChildScrollView
        child: Padding(
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
              ),
              SizedBox(height: 10),

              // Confirm New Password
              TextField(
                controller: _confirmNewPasswordController,
                decoration: InputDecoration(labelText: 'Confirm new password'),
                obscureText: true,
              ),
              SizedBox(height: 10),

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
        ),
      ),
    );
  }
}
