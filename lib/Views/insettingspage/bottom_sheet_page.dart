import 'package:flutter/material.dart';

void showGenderBottomSheet(BuildContext context, Function(String) updateGender) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Man'),
            onTap: () {
              updateGender('Man'); // Update the gender state
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Woman'),
            onTap: () {
              updateGender('Woman'); // Update the gender state
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
