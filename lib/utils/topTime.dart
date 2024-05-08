import 'package:flutter/material.dart';

// This is a helper function that shows the bottom sheet for time selection.
Future<double?> showTimeSelection(BuildContext context, Function(String) updateSortAndIcon) {
  return showModalBottomSheet<double>(
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
                    Navigator.pop(context, 0.3);
                  },
                ),
                ListTile(
                  title: Text('Today'),
                  onTap: () {
                    updateSortAndIcon('Today');
                    Navigator.pop(context, 1.0);
                  },
                ),
                ListTile(
                  title: Text('This Week'),
                  onTap: () {
                    updateSortAndIcon('This Week');
                    Navigator.pop(context, 7.0);
                  },
                ),
                ListTile(
                  title: Text('This Month'),
                  onTap: () {
                    updateSortAndIcon('This Month');
                    Navigator.pop(context, 30.0);
                  },
                ),
                ListTile(
                  title: Text('This Year'),
                  onTap: () {
                    updateSortAndIcon('This Year');
                    Navigator.pop(context, 365.0);
                  },
                ),
                ListTile(
                  title: Text('All Time'),
                  onTap: () {
                    updateSortAndIcon('All Time');
                    Navigator.pop(context, 500.0);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  ) ?? Future.value(0.0);
}