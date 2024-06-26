import 'package:curio/widgets/search_comment_card_test.dart';
import 'package:flutter/material.dart';
import 'commentConatiner.dart';
import 'package:curio/comment/viewPostComments.dart';

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


class SearchCommentCard extends StatelessWidget {
  final String communityImage;
  final String communityName;
  final String postTitle;
  final String commentContent;
  final int postUpvotes;
  final int commentUpvotes;
  final int numberOfComments;
  final String postCreatedAt;
  final String commentCreatedAt;
  final String userName;
  final String postID;


  const SearchCommentCard({
    super.key,
    required this.postID,
    required this.communityImage,
    required this.communityName,
    required this.postTitle,
    required this.commentContent,
    required this.postUpvotes,
    required this.commentUpvotes,
    required this.numberOfComments,
    required this.postCreatedAt,
    required this.commentCreatedAt,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home,
      Icons.star,
      Icons.school,
      Icons.work
    ]; // Add more icons as needed
    final iconData = icons[Random().nextInt(icons.length)];

    DateTime parsedCommentDate = DateTime.parse(commentCreatedAt);
    String formattedCommentDate = timeago.format(parsedCommentDate);

    DateTime parsedPostDate = DateTime.parse(postCreatedAt);
    String formattedPostDate = timeago.format(parsedPostDate);


    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                // any icon
                Icon(iconData),
                const SizedBox(width: 8),
                Text(communityName),
                const SizedBox(width: 8),
                Text(formattedPostDate),
              ],
            ),
            const SizedBox(height: 8),
            Text(postTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CommentContainer(
              userName: userName,
              createdAt: formattedCommentDate,
              commentContent: commentContent,
              upvotes: commentUpvotes,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to comments page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPostComments(postID: postID),
                  ),
                );
                // Add your action here
              },
              child: const Text(
                'Go to comments',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('$postUpvotes Upvotes •'),
                const SizedBox(width: 6),
                Text('$numberOfComments Comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}