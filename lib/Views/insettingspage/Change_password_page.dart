import 'package:flutter/material.dart';
import 'package:curio/utils/component_app_bar.dart';
import 'package:curio/views/signin/forgot_password_page.dart';
import 'package:curio/utils/component_user_info_sub_appbar.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

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
            ),
            SizedBox(height: 10),

            // Confirm New Password
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(labelText: 'Confirm new password'),
              obscureText: true,
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
                      // Save logic
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
