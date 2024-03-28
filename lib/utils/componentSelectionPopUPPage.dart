// SortPostsBottomSheet.dart
import 'package:flutter/material.dart';

void showSortPostsBottomSheet(BuildContext context, String initialSort, Function(String) updateSort) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      String selectedSort = initialSort; // Use the initial sort type passed to the function
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
                      updateSort(selectedSort); // Pass the selected sort type to the updateSort function
                      Navigator.of(context).pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              ...[
                {'sort': 'Hot', 'icon': Icons.whatshot},
                {'sort': 'New', 'icon': Icons.fiber_new},
                {'sort': 'Top', 'icon': Icons.grade},
                {'sort': 'Controversial', 'icon': Icons.thumbs_up_down},
                {'sort': 'Rising', 'icon': Icons.trending_up},
              ].map((Map<String, dynamic> item) {
                return RadioListTile<String>(
                  title: Text(item['sort']),
                  value: item['sort'],
                  groupValue: selectedSort,
                  secondary: Icon(item['icon']),
                  onChanged: (value) {
                    setModalState(() {
                      selectedSort = value!;
                    });
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
