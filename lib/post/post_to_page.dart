import 'dart:ffi';

import 'package:flutter/material.dart';

class PostToPage extends StatefulWidget {
  const PostToPage({Key? key}) : super(key: key);

  @override
  _PostToPageState createState() => _PostToPageState();
}

class _PostToPageState extends State<PostToPage> {
  final TextEditingController searchController = TextEditingController();
  String? selectedCommunity;
  List<String> allCommunities =
      List.generate(50, (index) => 'Community ${index + 1}');
  List<String> displayedCommunities = [];
  int itemCount = 3; // Initial number of items to display
  bool showButton = true; // Flag to control the visibility of the button

  @override
  void initState() {
    super.initState();
    displayedCommunities = List<String>.from(allCommunities.getRange(0, itemCount));    searchController.addListener(() {
      setState(() {
        displayedCommunities = allCommunities
            .where((community) => community
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    const sizeOf = MediaQuery.of;
    double maxWidth = keyboardOpen ? 150.0 : sizeOf(context).size.height * 0.6;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Post to',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        centerTitle: true, // This will center the title
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(26, 39, 45, 0.2),
                      filled: true,
                      hintText: 'Search for community',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.clear, size: 16),
                              ),
                              onPressed: () => searchController.clear(),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        displayedCommunities = allCommunities
                            .where((community) => community
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                if (searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: maxWidth,
              child: ListView.builder(
                itemCount: displayedCommunities.length + (showButton ? 1 : 0),
    itemBuilder: (context, index) {
                  if (index == displayedCommunities.length) {
                    // If this is the last item, return the "Load More" button
                    return showButton
                        ? OutlinedButton(
                            onPressed: () {
                              setState(() {
                                itemCount = allCommunities.length;
                                displayedCommunities = List<String>.from(allCommunities.getRange(0, itemCount));                                showButton = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.blue), // Blue border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners
                              ),
                              splashFactory: NoSplash
                                  .splashFactory, // Make splash color transparent
                            ),
                            child: const Text('See More'),
                          )
                        : Container(); // Return an empty Container when the button should not be shown
                  } else {
                    // Otherwise, return the ListTile for the community
                    return ListTile(
                      title: Text(displayedCommunities[index]),
                      onTap: () {
                        setState(() {
                          selectedCommunity = displayedCommunities[index];
                        });
                      },
                      tileColor: selectedCommunity == displayedCommunities[index]
                          ? Colors.blue[100] // Color when selected
                          : null, // Default color when not selected
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
