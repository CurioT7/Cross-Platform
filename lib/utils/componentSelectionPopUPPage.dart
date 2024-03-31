import 'package:flutter/material.dart';
import 'package:curio/utils/topTime.dart'; // Import the new page for time selection

// This is the showSortPostsBottomSheet function which shows a bottom sheet for sorting posts.
void showSortPostsBottomSheet(BuildContext context, String initialSort, Function(String, IconData) updateSortAndIcon, [bool isCommunity = false]) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      String selectedSort = initialSort; // Use the initial sort type passed to the function
      IconData selectedIcon = Icons.whatshot; // Default icon
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
                      updateSortAndIcon(selectedSort, selectedIcon); // Pass both selected sort type and icon to the updateSortAndIcon function
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              ...[
                {'sort': 'Hot', 'icon': Icons.whatshot},
                {'sort': 'New', 'icon': Icons.new_releases_outlined},
                {'sort': 'Top', 'icon': Icons.arrow_upward_sharp},
                {'sort': 'Random', 'icon': Icons.warning_amber_rounded},
                //if is community is true hide Rising
                if (!isCommunity){'sort': 'Rising', 'icon': Icons.trending_up},
                //{'sort': 'Rising', 'icon': Icons.trending_up},
              ].map((Map<String, dynamic> item) {
                return RadioListTile<String>(
                  title: Text(item['sort']),
                  value: item['sort'],
                  groupValue: selectedSort,
                  secondary: Icon(item['icon']),
                  onChanged: (value) {
                    // If 'Top' is selected, show the time selection bottom sheet.
                    if (value == 'Top') {
                      // Call the showTimeSelection function to show the bottom sheet.
                      showTimeSelection(context, (newSort) {
                        setModalState(() {
                          selectedSort = 'Top $newSort'; // Concatenate 'Top' with the selected time frame.
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
  );
}