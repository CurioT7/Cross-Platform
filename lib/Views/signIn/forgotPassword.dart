import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService apiService = ApiService();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite, // Set your desired color
        title: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Align items to the start and end of the row
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text(
                          'For any issues, please contact support at curio.cufe@gmail.com'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Help', style: TextStyle(color: redditGrey)),
            ),
          ],
        ),
      ),
      backgroundColor: redditBackgroundWhite, // Set your desired color

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context)
                    .padding
                    .top), // Add spacing to sit under the AppBar
            const Text('Reset Your Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text(
                'Enter your username and email address and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 20),
            CustomTextField('Username', _usernameController),
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
                  String username = _usernameController.text;
                  String email = _emailController.text;

                  // Check if the username is empty
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a username.'),
                      ),
                    );
                    return;
                  }

                  // Check if the email is empty
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter an email.'),
                      ),
                    );
                    return;
                  }

                  // Check if the email is valid
                  if (!email.contains('@') || !email.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid email.'),
                      ),
                    );
                    return;
                  }

                  try {
                    final response =
                        await apiService.resetPassword(username, email);
                    if (response['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'An email has been sent to reset your password.'),
                        ),
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Text(
                                'Please check your email to continue the password reset process.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to reset password: ${response['message']}'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occurred: $e'),
                      ),
                    );
                  }
                },
                child: const Text('Reset Password',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
