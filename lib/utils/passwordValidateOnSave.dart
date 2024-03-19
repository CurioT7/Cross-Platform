import 'package:flutter/material.dart';

void validateAndSave({
  required String newPassword,
  required String confirmNewPassword,
  String? email,
  required BuildContext context,
}) {
  // Validate email if provided
  if (email != null && email.isNotEmpty) {
    Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = RegExp(emailPattern.toString());
    if (!emailRegex.hasMatch(email)) {
      // Show error snack bar for invalid email
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
              child: Text('Invalid email format.'),
            ),
          ),
        ),
      );
      return;
    }
  }

  // Check if the password is less than 8 characters
  if (newPassword.length < 8) {
    // Show error snack bar for password length
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
            child: Text('Password should be at least 8 characters.'),
          ),
        ),
      ),
    );
    return;
  }

  // Check if the passwords match
  if (newPassword != confirmNewPassword) {
    // Show error snack bar for mismatched passwords
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
            child: Text('Passwords do not match.'),
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

  // Pop the current screen from the navigation stack
  Navigator.of(context).pop();
}
