import 'package:flutter/material.dart';

class TimeSelectionPage extends StatelessWidget {
  final Function(String) updateSortAndIcon;

  const TimeSelectionPage({required this.updateSortAndIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Now'),
          onTap: () {
            updateSortAndIcon('Now');
            Navigator.of(context).pop('Now'); // Pass the selected text back when popping the screen
          },
        ),
        ListTile(
          title: Text('Today'),
          onTap: () {
            updateSortAndIcon('Today');
            Navigator.of(context).pop('Today'); // Pass the selected text back when popping the screen
          },
        ),
        ListTile(
          title: Text('This Week'),
          onTap: () {
            updateSortAndIcon('This Week');
            Navigator.of(context).pop('This Week'); // Pass the selected text back when popping the screen
          },
        ),
        ListTile(
          title: Text('This Month'),
          onTap: () {
            updateSortAndIcon('This Month');
            Navigator.of(context).pop('This Month'); // Pass the selected text back when popping the screen
          },
        ),
        ListTile(
          title: Text('This Year'),
          onTap: () {
            updateSortAndIcon('This Year');
            Navigator.of(context).pop('This Year'); // Pass the selected text back when popping the screen
          },
        ),
        ListTile(
          title: Text('All Time'),
          onTap: () {
            updateSortAndIcon('All Time');
            Navigator.of(context).pop('All Time'); // Pass the selected text back when popping the screen
          },
        ),
      ],
    );
  }
}
