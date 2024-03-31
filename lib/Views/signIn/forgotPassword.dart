import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/passwordService.dart';
import 'resetPassword.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final PasswordService apiService = PasswordService();
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              onPressed: () => _requestPasswordReset(context),
              child: const Text('Help', style: TextStyle(color: redditGrey)),
            ),
          ],
        ),
      ),
      backgroundColor: redditBackgroundWhite,
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          const Text('Reset Your Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Enter your username and email address and we will send you a link to reset your password.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 20),
          CustomTextField('Username', _usernameController),
          const SizedBox(height: 20),
          CustomTextField('Email', _emailController),
          const SizedBox(height: 20),
          SizedBox(
            height: 50, 
            width: double.infinity, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redditOrange,
              ),
              onPressed: () => _requestPasswordReset(context),
              child: const Text('Request Password Reset', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _requestPasswordReset(BuildContext context) async {
    var response = await apiService.requestPasswordReset(
      _usernameController.text,
      _emailController.text,
    );

    var responseMap = jsonDecode(response.body);

    if (responseMap['success'] != null && responseMap['success']) {
      logger.i('Success');
      if (Navigator.canPop(context)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordPage()),
        );
      }
    } else {
      logger.i('Failure');
    }
  }
}