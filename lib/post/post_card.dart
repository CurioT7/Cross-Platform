import 'package:flutter/material.dart';

class PostCard2 extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final String? username;
  final String? postTime;
  final String? userImage;
  final String? postImage;

  const PostCard2({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    this.username,
    this.postTime,
    this.userImage,
    this.postImage,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard2> {
  int upvotes = 0;
  int downvotes = 0;
  int comments = 0;
  int shares = 0;
  bool pressed = false;
  bool upvotePressed = false;
  bool downvotePressed = false;
  bool commentPressed = false;
  bool sharePressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: widget.userImage != null
                      ? NetworkImage(widget.userImage!)
                      : null,
                ),
                title: Text(widget.username ?? 'Unknown'),
                subtitle: Text(widget.postTime ?? 'Unknown time'),
                trailing: const Icon(Icons.more_vert),
              ),
              if (widget.postImage != null)
                Image.network(
                  widget.postImage!,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.title),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_upward,
                              color: upvotePressed ? Colors.red : Colors.black),
                          onPressed: () {
                            setState(() {
                              upvotes =
                                  upvotePressed ? upvotes - 1 : upvotes + 1;
                              if (downvotePressed) {
                                downvotes--;
                                downvotePressed = false;
                              }
                              pressed = !pressed;
                              upvotePressed = !upvotePressed;
                            });
                          },
                        ),
                        Text(upvotes.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_downward,
                              color:
                                  downvotePressed ? Colors.red : Colors.black),
                          onPressed: () {
                            setState(() {
                              downvotes = downvotePressed
                                  ? downvotes - 1
                                  : downvotes + 1;
                              if (upvotePressed) {
                                upvotes--;
                                upvotePressed = false;
                              }
                              downvotePressed = !downvotePressed;
                              pressed = !pressed;
                            });
                          },
                        ),
                        Text(downvotes.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.comment,
                              color:
                                  commentPressed ? Colors.blue : Colors.black),
                          onPressed: () {
                            setState(() {
                              commentPressed = !commentPressed;
                              comments =
                                  commentPressed ? comments + 1 : comments - 1;
                            });
                          },
                        ),
                        Text(comments.toString()),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(), // Empty space
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share,
                              color: sharePressed ? Colors.blue : Colors.black),
                          onPressed: () {
                            setState(() {
                              sharePressed = !sharePressed;
                              shares = sharePressed ? shares + 1 : shares - 1;
                            });
                          },
                        ),
                        Text(shares.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
