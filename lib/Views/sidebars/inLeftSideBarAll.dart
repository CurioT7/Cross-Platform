// AllPage.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curio/utils/componentSelectionPopUPPage.dart'; // Make sure to import SortPostsBottomSheet.dart correctly

class AllPage extends StatefulWidget {
  const AllPage({Key? key}) : super(key: key);

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  String _selectedSort = 'Hot';
  IconData _selectedIcon = Icons.whatshot; // Default icon

  void _updateSortAndIcon(String newSort, IconData newIcon) {
    setState(() {
      _selectedSort = newSort;
      _selectedIcon = newIcon;
    });
    // TODO: Insert logic to fetch posts based on the _selectedSort
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
      ),
      body: Column(
        children: [
          Container(
            color:  Color(0xffF2F3F5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showSortPostsBottomSheet(context, _selectedSort, _updateSortAndIcon);
                  },
                  child: Row(
                    children: [
                      Icon(_selectedIcon), // Display the selected icon
                      Text(_selectedSort, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Other widgets for displaying posts can be added here
        ],
      ),
    );
  }
}