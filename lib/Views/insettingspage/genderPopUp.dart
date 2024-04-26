import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

void showGenderBottomSheet(BuildContext context, Function(String) updateGender) async {
  // Initialize SharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the previously selected gender, default to 'Man' if not set
  String _selectedGender = prefs.getString('selectedGender') ?? 'Man';

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                centerTitle: true,
                title: Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                automaticallyImplyLeading: false, // This hides the back button
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      // Save the selected gender to SharedPreferences
                      await prefs.setString('selectedGender', _selectedGender);

                      // Update gender using the API
                      await _handleGenderUpdate(context, _selectedGender);

                      // Update the gender in the UI
                      updateGender(_selectedGender);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'This information may be used to improve your recommendations and ads.',
                textAlign: TextAlign.center,
              ),
              RadioListTile<String>(
                title: Text('Man'),
                value: 'Man',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setModalState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Woman'),
                value: 'Woman',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setModalState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              // Add any other gender options here
            ],
          );
        },
      );
    },
  );
}

Future<void> _handleGenderUpdate(BuildContext context, String gender) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      var responseData = await ApiServiceMahmoud().updateGender(token, gender);
      if (responseData['message'] != null) {
        print(responseData['preferences']['gender']);
        print('this is the responce recived');
        print(responseData['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token is null. Please log in again.'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update gender: $e'),
      ),
    );
  }
}

