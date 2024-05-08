import 'package:flutter/material.dart';
import 'package:curio/comment/viewPostComments.dart';

class SavedCommentCard extends StatelessWidget {
  final String content;
  final String title;
  final String postID;
  final String metaData;

  SavedCommentCard(
      {Key? key,
        required this.title,
        required this.content,
        required this.postID,
        required this.metaData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewPostComments(postID: postID),
          ),
        );
        // Add your action here
      },
      child: Card(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
                Text(
                  metaData,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}