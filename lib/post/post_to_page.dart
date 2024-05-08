import 'package:flutter/material.dart';
import 'package:curio/post/community_card.dart';
import 'package:curio/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Models/community_model.dart';

class PostToPage extends StatefulWidget {
  const PostToPage({Key? key}) : super(key: key);

  @override
  _PostToPageState createState() => _PostToPageState();
}

class _PostToPageState extends State<PostToPage> {
  final TextEditingController searchController = TextEditingController();
  Future<List<Community>>? communities;
  List<Community> communityList = [];
  List<Community> displayedCommunities = [];
  int itemCount = 3; // Initial number of items to display
  bool showButton = true; // Flag to control the visibility of the button

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String token = sharedPrefs.getString('token')!;
    // get the communities from the API
    print('Fetching communities from user token: $token');
    communities = ApiService().getCommunities(token, context);
    if (communities != null) {
      communityList = await communities!;
      displayedCommunities = communityList.sublist(0, itemCount);
      searchController.addListener(() {
        setState(() {
          displayedCommunities = communityList
              .where((community) => community.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
        });
      });
    }
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
                        displayedCommunities = communityList
                            .where((community) => community.name
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
                                displayedCommunities = List<Community>.from(
                                    communityList); // Display all items
                                showButton = false;
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
                    // Otherwise, return the CommunityCard for the community
                    return CommunityCard(
                      community: displayedCommunities[index],
                      onTap: () {
                        // send the selected community to the post screen
                        Navigator.pop(context, displayedCommunities[index]);
                      },
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
