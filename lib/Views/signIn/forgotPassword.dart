import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatelessWidget {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite, // Set your desired color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the start and end of the row
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/Curio.png',
                    fit: BoxFit.contain,
                    height: 60,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Implement help button logic
              },
              child: const Text('Help', style: TextStyle(color: redditGrey)),
            ),
          ],
        ),
      ),
      backgroundColor: redditBackgroundWhite, // Set your desired color
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top), // Add spacing to sit under the AppBar
          const Text('Reset Your Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Enter your email address or username and we will send you a link to reset your password.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 20),
          CustomTextField('Email', _emailController),
          const SizedBox(height: 20),
          Container(
            height: 50, 
            width: double.infinity, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redditOrange,
              ),
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://localhost:3000/api/auth/reset_password/{token}'), // Replace {token} with the actual token
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'password': _emailController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  print('Password reset successful');
                } else {
                  print('Failed to reset password: ${response.body}');
                }
              },
              child: const Text('Reset Password', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}