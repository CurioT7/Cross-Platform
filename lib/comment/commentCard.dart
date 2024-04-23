import 'package:curio/comment/editComment.dart';
import 'package:curio/comment/viewPostComments.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/Models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:curio/services/logicAPI.dart';
class CommentCard extends StatefulWidget {


  final Post post;
  final String id;
  final String content;
  final String authorUsername;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final String linkedPost;
  final String linkedSubreddit;
  final int awards;
final String? userImage;

   CommentCard({
    Key? key,
     required this.post,
    required this.id,
    required this.content,
    required this.authorUsername,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.linkedPost,
    required this.linkedSubreddit,
    required this.awards,
    this.userImage,
  }) : super(key: key);


  @override
  _CommentCardState createState() => _CommentCardState();


}

class _CommentCardState extends State<CommentCard> {
  bool upvotePressed = false;
  bool downvotePressed = false;
  int upvotes = 0;
  int downvotes = 0;

  Map<String, dynamic>? userDetails;
  String? username;
  Future<Map<String, dynamic>> _fetchUsername() async {
    try {
      final logicAPI apiLogic = logicAPI();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final username = await apiLogic.fetchUsername(token);
      final data = apiLogic.extractUsername(username);
      print('DATA HERE');
      print(data);
      return data;
      await prefs.remove('token');
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    upvotes = widget.upvotes;
    downvotes = widget.downvotes;
  }

  @override
  Widget build(BuildContext context) {

    return Container(


        child: Padding(
        padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Colors.white,
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                  widget.userImage != null ? AssetImage(widget.userImage!) : null,
                ),
                SizedBox(width: 8.0),
                Text(widget.authorUsername ?? 'Unknown',  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),),
                SizedBox(width: 8.0),
                Text(widget.createdAt != null ?  '${timeago.format(widget.createdAt!)}' : 'Unknown time',
                //set text color to grey
                style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.content),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: IconTheme(
                    data: IconThemeData(
                      size: 30,  // Adjust this value as needed
                    ),
                    child: Icon(Icons.arrow_upward, color: upvotePressed ? Colors.red : Colors.black),
                  ),
                  onPressed: () {
                    if (upvotePressed == false) {
                      setState(() {
                        upvotes = upvotes + 1;
                        upvotePressed = true;
                        downvotePressed = false;
                      });
                    }
                  }
                    ,

                ),
                Text((upvotes- downvotes).toString()),
                IconButton(
                  icon: IconTheme(
                    data: IconThemeData(
                      size: 30,  // Adjust this value as needed
                    ),
                    child: Icon(Icons.arrow_downward, color: downvotePressed ? Colors.red : Colors.black),
                  ),
                  onPressed: () {
                    if (downvotePressed == false)
                      setState(() {
                      downvotes = downvotes + 1;
                      downvotePressed = true;
                      upvotePressed = false;

                    });
                  },
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: _fetchUsername(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while waiting for _fetchUsername to complete
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Show error message if _fetchUsername fails
                    } else {
                      username = snapshot.data!['username'];
                     // Extract the username from the snapshot data
                      if (username == widget.authorUsername) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => editComment(post: widget.post, commentId: widget.id)),
                                );
                              },
                              icon: Icon(
                                Icons.more_vert,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDeleteCommentDialog(context,); // Replace 'communityName' with the actual community name
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(); // Return an empty container if the username doesn't match
                      }
                    }
                  },
                )

              ],
            ),
          ],
        ),
      ),
    )
    )
    );
  }
  void showDeleteCommentDialog(BuildContext context,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Container(
            width: MediaQuery
                .of(context)
                .size
                .width *1.6,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.14,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Are you sure you want to delete this comment?',
                    textAlign: TextAlign.left,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.07,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text(
                                'Cancel', style: TextStyle(color: Colors.grey)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                                'Delete', style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              logicAPI api = logicAPI();


                              try {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                String? token = prefs.getString('token');
                                if (token == null) {
                                  throw Exception('Token is null');
                                }
                                api.deleteComment(widget.id, token);
                                Navigator.of(context).pop();

                              }
                              catch(e){
                                print(e);
                              }

                              api.fetchPostComments(widget.post.id);Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewPostComments(post: widget.post),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                            30.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Text(
                                          'You have deleted the comment',
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  )
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}