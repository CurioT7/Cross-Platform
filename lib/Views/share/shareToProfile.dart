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
  // Define variables to hold post information
  String postId = '';
  String postTitle = '';
  String postContent = '';
  String authorName = '';
  String createdAt = '';
  String mediaUrl = '';

  @override
  void initState() {
    super.initState();
    fetchPostInfo(widget.oldPostId);
  }

  Future<void> fetchPostInfo(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        // Call the getInfo function to get post info
        Map<String, dynamic> postInfo =
        await ApiServiceMahmoud().getInfo(token, postId, 'post');
        // Update state with post information
        setState(() {
          postId = postInfo['item']['_id'] ?? '';
          postTitle = postInfo['item']['title'] ?? '';
          postContent = postInfo['item']['content'] ?? '';
          authorName = postInfo['item']['authorName'] ?? '';
          createdAt = postInfo['item']['createdAt'] ?? '';
          mediaUrl = postInfo['item']['media'] ?? '';
        });
      } catch (e) {
        // Handle errors
        print('Error fetching post info: $e');
      }
    } else {
      // Handle case when token is not available
      print('Token not found. Please login again.');
    }
  }

  Future<void> sharePost(String title, String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // If token is available, make the post request
      print('Token: $token');
      print('Title: $title');
      print('Post ID: $postId');
      Map<String, dynamic> response =
      await ApiServiceMahmoud().sharePostToProfile(token, title, postId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crosspost'),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              sharePost(postTitle, widget.oldPostId);
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
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Column(
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
                        MaterialPageRoute(
                          builder: (context) => ChooseCommunityPage(
                            oldPostId: widget.oldPostId,
                          ),
                        ),
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
                controller: TextEditingController(text: postTitle),
                onChanged: (newValue) {
                  postTitle = newValue;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(),
            ListTile(
              subtitle: Text('u/$authorName. $createdAt'),
              title: Text(postTitle),
            ),
            // Show media if available
            // Show post content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(postContent),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
