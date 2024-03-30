import 'package:flutter/material.dart';

// This is a helper function that shows the bottom sheet for time selection.
void showTimeSelection(BuildContext context, Function(String) updateSortAndIcon) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Material(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Now'),
                  onTap: () {
                    updateSortAndIcon('Now');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Today'),
                  onTap: () {
                    updateSortAndIcon('Today');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('This Week'),
                  onTap: () {
                    updateSortAndIcon('This Week');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('This Month'),
                  onTap: () {
                    updateSortAndIcon('This Month');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('This Year'),
                  onTap: () {
                    updateSortAndIcon('This Year');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('All Time'),
                  onTap: () {
                    updateSortAndIcon('All Time');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}