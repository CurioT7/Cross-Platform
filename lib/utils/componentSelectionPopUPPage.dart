import 'package:flutter/material.dart';
import 'package:curio/utils/topTime.dart'; // Import the new page for time selection
import 'dart:async';
Future<double?> showSortPostsBottomSheet(BuildContext context, String initialSort, IconData selectedIcon, Function(String, IconData) updateSortAndIcon, Function(String) fetchPosts, [bool isCommunity = false]) {
  Future<double?> timeSelected = Future.value(null);
  var completer = Completer<double?>();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      String selectedSort = initialSort;
      IconData selectedSortIcon = selectedIcon; // Store the selected icon separately
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                centerTitle: true,
                title: Text('Sort Posts', style: TextStyle(fontWeight: FontWeight.bold)),
                automaticallyImplyLeading: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      updateSortAndIcon(selectedSort, selectedSortIcon); // Pass the selected icon
                      print('Selected Sort: $selectedSort');
                      fetchPosts(selectedSort); // Fetch posts based on the selected sorting criteria
                      Navigator.of(context).pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              ...[
                {'sort': 'hot', 'icon': Icons.whatshot},
                {'sort': 'new', 'icon': Icons.new_releases_outlined},
                {'sort': 'top', 'icon': Icons.arrow_upward_sharp},
                if (!isCommunity){'sort': 'random', 'icon': Icons.shuffle},
                if (!isCommunity){'sort': 'rising', 'icon': Icons.trending_up},
              ].map((Map<String, dynamic> item) {
                return RadioListTile<String>(
                  title: Text(item['sort']),
                  value: item['sort'],
                  groupValue: selectedSort,
                  secondary: Icon(item['icon']),
                  onChanged: (value) {
                    if (value == 'top') {
                      // Call the showTimeSelection function to show the bottom sheet.
                      timeSelected= showTimeSelection(context, (newSort) {
                        setModalState(() {
                         selectedSort = 'top $newSort';
//print timeSelected
                          timeSelected.then((value) => print('Time Selected: $value'));
                          print('Selected Sort: $selectedSort');
                          selectedIcon = Icons.arrow_upward_sharp; // Keep the same icon for 'Top'.
                        });
                      });
                    } else {
                      // For other sort types, just update the state.

                      setModalState(() {
                        selectedSort = value ?? ''; // Ensure the value is non-nullable.
                        selectedIcon = item['icon']; // Update the icon for the selected sort type.
                      });
                    }

                  },
                );
              }).toList(),
            ],
          );
        },
      );
    },
  ).then((_) {
    completer.complete(timeSelected);
  });

  return completer.future;
}
