import 'package:curio/services/logicAPI.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/comment.dart';
import 'package:curio/comment/commentCard.dart';
import 'package:curio/comment/topBar.dart';
import 'package:curio/Models/post.dart';
//import 'package:curio/post/post_card.dart';
import 'package:curio/comment/newComment.dart';
import 'package:curio/widgets/postCard.dart';
class ViewPostComments extends StatefulWidget {

  final Post post;

  ViewPostComments({required this.post});
  @override
  _ViewPostCommentsState createState() => _ViewPostCommentsState();
}

class _ViewPostCommentsState extends State<ViewPostComments> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    logicAPI().fetchPostComments(widget.post.id);
  }@override
  Widget build(BuildContext context) {
    print('Post: ${widget.post.title}');
    print('Post: ${widget.post.content}');
String postTitle = widget.post.title;
String postcontent = widget.post.content;

    return Scaffold(
      //set color of page to ligth grey
      backgroundColor: Colors.grey[200],
    appBar: topAppBar(context),
      body: Column(
        children: <Widget>[
          Container(
            child: PostCard(post: widget.post,),
          ),// Wrap the PostCard widget with an Expanded widget
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: logicAPI().fetchPostComments(widget.post.id),
              builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData) {
                  List<Comment> comments = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      print('Comment ${index + 1}: ${comments[index].content}');
                      return CommentCard(
                        post: widget.post,
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
                  return CircularProgressIndicator();
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
                          MaterialPageRoute(builder: (context) => newComment(post:widget.post)),
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