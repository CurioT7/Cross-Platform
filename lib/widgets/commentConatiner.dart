import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final String userName;
  final String createdAt;
  final String commentContent;
  final int upvotes;

  const CommentContainer({
    Key? key,
    required this.commentContent,
    required this.upvotes,
    required this.userName,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
        ),
      ),
      constraints: const BoxConstraints(
        maxHeight: 100, // Set your desired max height here
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle), // This is the icon
                  const SizedBox(width: 8),
                  Text(userName), // This is the user name
                  const SizedBox(width: 8),
                  Text(createdAt), // This is the post creation date
                ],
              ),
              const SizedBox(height: 8),
              Text(
                commentContent,
                overflow:
                    TextOverflow.fade, // This will fade the overflowing text
                softWrap:
                    false, // This will prevent the text from wrapping to the next line
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Text('$upvotes Upvotes'),
          ),
        ],
      ),
    );
  }
}
