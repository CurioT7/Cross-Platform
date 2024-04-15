import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart'; // This is assumed to contain the Post class
import 'package:curio/Models/post.dart'; // Import the Post model
import 'package:shared_preferences/shared_preferences.dart';

class ShareToProfilePage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    // Extract the necessary data for display
    String nameofcommunity = samplePost.linkedSubreddit ?? 'Unknown Community';
    String authorName = samplePost.authorName ?? 'Anonymous';
    String createdAt = samplePost.createdAt.toString();
    String mediaUrl = samplePost.media ?? '';

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
              // Handle the onTap event here
              // You can add your functionality to post something
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
                  child: Icon(Icons.person), // Placeholder for your Curio image asset
                  radius: 30,
                ),
                SizedBox(width: 10),
                Text('My profile'),
                Spacer(),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController, // Set the controller
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(samplePost.title ?? 'No Title'),
            subtitle: Text('r/$nameofcommunity. u/$authorName. $createdAt'),
          ),
          Divider(),
        ],
      ),
    );
  }
}
