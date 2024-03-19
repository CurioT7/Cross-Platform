import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/utils/passwordValidateOnSave.dart';

class ConnectToGooglePage extends StatefulWidget {
  const ConnectToGooglePage({Key? key}) : super(key: key);

  @override
  State<ConnectToGooglePage> createState() => _ConnectToGooglePageState();
}

class _ConnectToGooglePageState extends State<ConnectToGooglePage> {
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
            Text('For your security, confirm your password to finish disconnecting your account.'),
            // New Password
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Reddit Passsword'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _isNewPasswordValid = value.length >= 8;
                  _arePasswordsMatching = value == _confirmNewPasswordController.text;
                });
              },
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
                    onPressed: () {
                      // Validate new password and password match
                      validateAndSave(
                        newPassword: _newPasswordController.text,
                        confirmNewPassword: _newPasswordController.text,
                        context: context,
                      );
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
}
