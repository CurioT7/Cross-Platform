import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:curio/Models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/Views/community/chooseCommunity.dart';

class ShareToProfilePage extends StatefulWidget {
  final String oldPostId;

  ShareToProfilePage({required this.oldPostId});

  @override
  _ShareToProfilePageState createState() => _ShareToProfilePageState();
}

class _ShareToProfilePageState extends State<ShareToProfilePage> {
  // Instantiate the Post object using the sample data
  final Post samplePost = Post.fromJson({
    "_id": "65fba6e0aab809eceb312466",
    "title": "this is the post title.",
    "content": "post conntecnt.",
    "authorName": "Cecile56",
    "views": 14611,
    "createdAt": "2024-03-16T03:23:13.002Z",
    "upvotes": 58542,
    "downvotes": 11880,
    "linkedSubreddit": "65fba6dbaab809eceb3123ee",
    "comments": [],
    "shares": 91827,
    "isNSFW": true,
    "isSpoiler": false,
    "isOC": true,
    "isCrosspost": true,
    "awards": 96140,
    "media": "https://nayeli.name",
    "link": "https://brandon.biz",
    "isDraft": true,
    "__v": 0
  });

  Future<void> sharePost(String title, String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // If token is available, make the post request
      print('Token: $token');
      print('Title: $title');
      print('Post ID: $postId');
      Map<String, dynamic> response = await ApiServiceMahmoud().sharePostToProfile(token, title, postId);
      print(response);
      // Show snackbar based on the response
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // Function to fetch post info
  Future<void> fetchPostInfo(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        // Call the getInfo function to get post info
        Map<String, dynamic> postInfo = await ApiServiceMahmoud().getInfo(token, postId, 'post');
        // Print post info
        print('Post Info: $postInfo');
      } catch (e) {
        // Handle errors
        print('Error fetching post info: $e');
      }
    } else {
      // Handle case when token is not available
      print('Token not found. Please login again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call fetchPostInfo function to get post details
    fetchPostInfo(widget.oldPostId);

    // Extract the necessary data for display
    String nameofcommunity = samplePost.linkedSubreddit ?? 'Unknown Community';
    String authorName = samplePost.authorName ?? 'Anonymous';
    String createdAt = samplePost.createdAt.toString();
    String mediaUrl = samplePost.media ?? '';
    String NewSubreddit = 'My profile'; // Initial text
    // Controller for the TextField
    TextEditingController titleController =
    TextEditingController(text: samplePost.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crosspost'),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              // Call the function to share post to profile
               sharePost(titleController.text, widget.oldPostId);  // Pass the title and old post ID
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: Text(
                'Post',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('lib/assets/images/Curio.png'),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Text('My profile'),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseCommunityPage(oldPostId: widget.oldPostId)),
                    );
                  },
                  child: Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController, // Set the controller
              onChanged: (newValue) {
                titleController.text = newValue;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Divider(),
          ListTile(
            subtitle: Text('r/$nameofcommunity. u/$authorName. $createdAt'),
            title: Text(samplePost.title ?? 'No Title'),
          ),
          Divider(),
        ],
      ),
    );
  }
}
