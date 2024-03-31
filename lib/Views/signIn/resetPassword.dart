import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/passwordService.dart';
import 'package:logger/logger.dart';

class ResetPasswordPage extends StatelessWidget {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final PasswordService passwordService = PasswordService();
  final logger = Logger();

  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
        title: const Text('Reset Password', style: TextStyle(color: redditGrey)),
      ),
      backgroundColor: redditBackgroundWhite,
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          const Text('Enter Your New Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CustomTextField('Reset Token', _tokenController),
          const SizedBox(height: 20),
          CustomTextField('New Password', _passwordController),
          const SizedBox(height: 20),
          SizedBox(
            height: 50, 
            width: double.infinity, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redditOrange,
              ),
              onPressed: () async {
                var response = await passwordService.resetPassword(
                  _tokenController.text,
                  _passwordController.text,
                );
                var responseMap = jsonDecode(response.body);
                if (responseMap['success'] != null && responseMap['success']) {
                  logger.i('Password reset successful');
                } else {
                  logger.i('Failed to reset password');
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