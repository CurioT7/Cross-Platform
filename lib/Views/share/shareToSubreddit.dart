import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:curio/Models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Views/community/chooseCommunity.dart';
import 'package:curio/Views/community/chooseCommunity2.dart';

class ShareToSubredditPage extends StatefulWidget {
  final String selectedNewSubreddit;

  ShareToSubredditPage({required this.selectedNewSubreddit});

  @override
  _ShareToSubredditPageState createState() => _ShareToSubredditPageState();
}

class _ShareToSubredditPageState extends State<ShareToSubredditPage> {
  TextEditingController titleController = TextEditingController();
  late Post samplePost;
  late String _selectedNewSubreddit; // Declare _selectedNewSubreddit here

  @override
  void initState() {
    super.initState();
    _selectedNewSubreddit = widget.selectedNewSubreddit; // Initialize _selectedNewSubreddit from widget
    // Initialize the samplePost and titleController here
    samplePost = Post.fromJson({
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
    titleController.text = samplePost.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    String nameofcommunity = samplePost.linkedSubreddit ?? 'Unknown Community';
    String authorName = samplePost.authorName ?? 'Anonymous';
    String createdAt = samplePost.createdAt.toString();
    String mediaUrl = samplePost.media ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Crosspost'),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              print('Post');
              print('this is the share to subreddit page');
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
                Text(_selectedNewSubreddit.isEmpty ? 'my profile' : 'r/$_selectedNewSubreddit'),
                GestureDetector(
                  onTap: () async {
                    final newSubreddit = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseCommunityPage2()),
                    );
                    setState(() {
                      _selectedNewSubreddit = newSubreddit;
                    });
                  },
                  child: Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
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
