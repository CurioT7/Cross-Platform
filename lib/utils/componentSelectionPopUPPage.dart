import 'package:flutter/material.dart';
import 'package:curio/utils/topTime.dart'; // Import the new page for time selection

void showSortPostsBottomSheet(BuildContext context, String initialSort, Function(String, IconData) updateSortAndIcon) {
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
                      Navigator.of(context).pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              ...[
                {'sort': 'Hot', 'icon': Icons.whatshot},
                {'sort': 'New', 'icon': Icons.new_releases_outlined},
                {'sort': 'Top', 'icon': Icons.arrow_upward_sharp},
                {'sort': 'Controversial', 'icon': Icons.warning_amber_rounded},
                {'sort': 'Rising', 'icon': Icons.trending_up},
              ].map((Map<String, dynamic> item) {
                return RadioListTile<String>(
                  title: Text(item['sort']),
                  value: item['sort'],
                  groupValue: selectedSort,
                  secondary: Icon(item['icon']),
                  onChanged: (value) {
                    if (value == 'Top') {
                      // Navigate to the TimeSelectionPage if "Top" is selected
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TimeSelectionPage(updateSortAndIcon: (newSort) {
                            setModalState(() {
                              selectedSort = 'Top $newSort'; // Concatenate "Top" with the selected value
                              selectedIcon = Icons.arrow_upward_sharp;
                            });
                          }),
                        ),
                      );
                    } else {
                      setModalState(() {
                        selectedSort = value ?? ''; // Ensure value is non-nullable
                        selectedIcon = item['icon'];
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
