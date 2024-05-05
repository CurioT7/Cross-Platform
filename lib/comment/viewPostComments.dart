import 'package:curio/services/logicAPI.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/comment.dart';
import 'package:curio/comment/commentCard.dart';
import 'package:curio/comment/topBar.dart';
import 'package:curio/Models/post_header.dart';
//import 'package:curio/post/post_card.dart';
import 'package:curio/comment/newComment.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/post.dart';

class ViewPostComments extends StatefulWidget {

  final String postID;

  ViewPostComments({required this.postID});
  @override
  _ViewPostCommentsState createState() => _ViewPostCommentsState();
}
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  return token;
}
class _ViewPostCommentsState extends State<ViewPostComments> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    logicAPI().fetchPostComments(widget.postID);
  }@override
  Widget build(BuildContext context) {


    return Scaffold(
      //set color of page to ligth grey
      backgroundColor: Colors.grey[200],
    appBar: topAppBar(context),
      body: Column(
        children: <Widget>[
      Container(
      child: FutureBuilder<Post>(
          future: () async {

    return logicAPI().fetchPostByID(widget.postID , await getToken());
    }(),
    builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Container(); // Show a loading spinner while waiting
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}'); // Show error message if something went wrong
    } else {
    return Container(
    child: PostCard(post: snapshot.data!.post),
    );

                }
              },
            ),
          ),// Wrap the PostCard widget with an Expanded widget
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: logicAPI().fetchPostComments(widget.postID),
              builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData) {
                  List<Comment> comments = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      print('Comment ${index + 1}: ${comments[index].content}');
                      return CommentCard(
                        postID: widget.postID,
                        id: comments[index].id,
                        content: comments[index].content,
                        authorUsername: comments[index].authorUsername,
                        createdAt: comments[index].createdAt,
                        upvotes: comments[index].upvotes,
                        downvotes: comments[index].downvotes,
                        linkedPost: comments[index].linkedPost,
                        linkedSubreddit: comments[index].linkedSubreddit,
                        awards: comments[index].awards,
                        userImage: "lib/assets/images/example.jpg",
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(

                    child: TextField(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => newComment(postID:widget.postID)),
                        );
                      },
                      decoration: InputDecoration(
                        labelText: 'Add a comment',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.expand_more),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}