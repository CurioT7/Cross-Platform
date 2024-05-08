import 'package:curio/comment/editComment.dart';
import 'package:curio/comment/viewPostComments.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/Models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:curio/services/logicAPI.dart';
class CustomIcons {
  static const IconData bookmarks_outlined = IconData(0xeee5, fontFamily: 'MaterialIcons');
}
class CommentCard extends StatefulWidget {


  final String postID;
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
    required this.postID,
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
  //TODO ADJUST SAVE COMMENT INITIAL STate
  String? image;
  bool savePressed = false;
  bool upvotePressed = false;
  bool downvotePressed = false;
  int upvotes = 0;
  int downvotes = 0;
  void checkIfCommentIsSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      List<String> savedCommentIds = await logicAPI().fetchSavedCommentIds(
          token);
      setState(() {
        savePressed = savedCommentIds.contains(widget.id);
      });
    } else {
      throw Exception('Token is null');
    }
  }

  void fetchAndSetUserImage() async {
    logicAPI api = logicAPI();
    Map<String, dynamic> userData = await api.fetchUserData(widget.authorUsername);
    Map<String, dynamic> userDetails = await api.extractUserDetails(userData);
    setState(() {
      image = userDetails['profilePicture'];
      print("image link: $image");
    });
  }

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
    fetchAndSetUserImage();
    upvotes = widget.upvotes;
    downvotes = widget.downvotes;
    checkIfCommentIsSaved();
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
                          backgroundImage: image != null ? NetworkImage(image!) : null,
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
                          onPressed: () async {
                            if (upvotePressed == false && downvotePressed==false) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, 1, token);
                                setState(() {
                                  upvotes = upvotes + 1;
                                  upvotePressed = true;
                                  downvotePressed = false;
                                });
                              } else {
                                throw Exception('Token is null');
                              }
                            } else if (upvotePressed == true && downvotePressed==false) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, 0, token);
                                setState(() {
                                  upvotes = upvotes - 1;
                                  upvotePressed = false;
                                  downvotePressed = false;
                                });
                              } else {
                                throw Exception('Token is null');
                              }
                            }
                            else if (upvotePressed == false && downvotePressed==true) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, 0, token);
                                await logicAPI().voteComment(widget.id, 1, token);
                                setState(() {
                                  upvotes = upvotes + 2;
                                  upvotePressed = true;
                                  downvotePressed = false;
                                });
                              } else {
                                throw Exception('Token is null');
                              }
                            }
                          },
                        ),
                        Text((upvotes- downvotes).toString()),
                        IconButton(
                          icon: IconTheme(
                            data: IconThemeData(
                              size: 30,  // Adjust this value as needed
                            ),
                            child: Icon(Icons.arrow_downward, color: downvotePressed ? Colors.red : Colors.black),
                          ),
                          onPressed: () async {
                            if (downvotePressed == false && upvotePressed==false) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, -1, token);
                                setState(() {
                                  downvotes = downvotes + 1;
                                  downvotePressed = true;
                                  upvotePressed = false;
                                });
                              }
                            } else if (downvotePressed == true && upvotePressed==false){
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, 0, token);
                                setState(() {
                                  downvotes = downvotes - 1;
                                  downvotePressed = false;
                                  upvotePressed = false;
                                });
                              }
                            }
                            else if (downvotePressed == false && upvotePressed==true){
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token != null) {
                                await logicAPI().voteComment(widget.id, 0, token);
                                await logicAPI().voteComment(widget.id, -1, token);

                                setState(() {
                                  downvotes = downvotes + 2;
                                  downvotePressed = true;
                                  upvotePressed = false;
                                });
                              }
                            }
                          },
                        ),
                        FutureBuilder<Map<String, dynamic>>(
                          future: _fetchUsername(),
                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              username = snapshot.data!['username'];
                              List<Widget> children = [];
                              if (username == widget.authorUsername) {
                                children.addAll([
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => editComment(postID: widget.postID, commentId: widget.id)),
                                      );
                                    },
                                    icon: Icon(Icons.more_vert),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDeleteCommentDialog(context,);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ]);
                              }
                              children.add(IconButton(
                                onPressed: () async {
                                  if (savePressed == false) {
                                    setState(()  {
                                      savePressed = true;
                                    });
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? token = prefs.getString('token');
                                    if (token != null) {
                                      logicAPI().saveComment(widget.id, token);
                                    } else {
                                      throw Exception('Token is null');
                                    }
                                  }
                                  else{
                                    setState(() {
                                      savePressed = false;
                                    });
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? token = prefs.getString('token');
                                    if (token != null) {
                                      logicAPI().unsaveComment(widget.id, token);
                                    } else {
                                      throw Exception('Token is null');
                                    }
                                  }
                                },
                                icon: Icon(savePressed ? Icons.bookmark : Icons.bookmark_border),
                              ));
                              return Row(children: children);
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
                              api.fetchPostComments(widget.postID);Navigator.of(context).push(
                                MaterialPageRoute(

                                  builder: (context) => ViewPostComments(postID: widget.postID),
                                ),
                              );
                              api.fetchPostComments(widget.postID);
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