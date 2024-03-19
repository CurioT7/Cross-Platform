import 'package:flutter/material.dart';
import 'package:curio/utils/component_app_bar.dart';
import 'package:curio/utils/component_user_info_sub_appbar.dart';
import 'package:curio/views/signin/forgot_password_page.dart';

class UpdateEmailAdressPage extends StatefulWidget {
  @override
  State<UpdateEmailAdressPage> createState() => _UpdateEmailAdressPageState();
}

class _UpdateEmailAdressPageState extends State<UpdateEmailAdressPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
                    print(_obscureText);
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
    );
  }
}
