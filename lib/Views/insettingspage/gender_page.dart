import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                title: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold),),
                automaticallyImplyLeading: false, // This hides the back button
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      // Save the selected gender to SharedPreferences
                      await prefs.setString('selectedGender', _selectedGender);

                      updateGender(_selectedGender);
                      Navigator.of(context).pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              Text('This information may be used to improve your recommendations and ads.', textAlign: TextAlign.center),

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
