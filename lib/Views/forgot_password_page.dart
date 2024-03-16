import 'package:flutter/material.dart';
import 'reddit_colors.dart'; // Import the Reddit color palette

class ForgotPasswordPage extends StatelessWidget {
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
              onPressed: () {
                // Implement help button logic
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
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email or Username',
              fillColor: redditGrey,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none, // Set border side to none
                ), enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none, // Set border side to none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: Colors.black), // Set border side to a visible color when focused
                ),
            ),
            onChanged: (value) {
              // Implement email or username change logic
            },
          ),
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