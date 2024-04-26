import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/views/signIn/forgotPassword.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class ConnectedAccountsPage extends StatefulWidget {
  @override
  _ConnectedAccountsPageState createState() => _ConnectedAccountsPageState();
}

class _ConnectedAccountsPageState extends State<ConnectedAccountsPage> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _isNewPasswordValid = false;
  bool _arePasswordsMatching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(
        title: 'Connected Accounts',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserInfoSubBar(),
            // New Password
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _isNewPasswordValid = value.length >= 8;
                  _arePasswordsMatching =
                      value == _confirmNewPasswordController.text;
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
                  _arePasswordsMatching = value == _newPasswordController.text;
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
                      // Validate new password and password match
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
    // Check if any of the passwords is less than 8 characters or they don't match
    if (!_isNewPasswordValid || !_arePasswordsMatching) {
      // Show error snack bar
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
              child:
                  Text('Passwords should be at least 8 characters and match.'),
            ),
          ),
        ),
      );
      return;
    }

    // If everything is valid, proceed with saving
    // Save logic
    print('Updating connected accounts...');
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
            child: Text('Connected accounts updated successfully.'),
          ),
        ),
      ),
    );
  }
}
