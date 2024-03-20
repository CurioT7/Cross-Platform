import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/services/api_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redditBackgroundWhite,
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
              onPressed: () async{
                // Implement help button logic
                var response= await apiService.ForgotPassword(_emailController.text);
                if(response['success'] == true) {
                  // Implement success logic
                  print('Success');
                } else {
                  // Implement failure logic
                  print('Failure');
                }

              },
              child: const Text('Help', style: TextStyle(color: redditGrey)),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top), // Add spacing to sit under the AppBar
          const Text('Reset Your Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Enter your email address or username and we will send you a link to reset your password.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 20),
          CustomTextField('Email', _emailController),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: redditOrange,
            ),
            onPressed: () {
              // Implement reset password logic
            },
            child: const Text('Reset Password', style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
    );
  }
}