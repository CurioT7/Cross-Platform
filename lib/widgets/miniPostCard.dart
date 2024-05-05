import 'package:curio/Models/minipost.dart';
import 'package:curio/Models/post_header.dart';
import 'package:curio/comment/viewPostComments.dart';
import 'package:curio/services/postService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MiniPostCard extends StatelessWidget {
  final MiniPost miniPost;

  MiniPostCard({required this.miniPost});
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    return '${difference.inDays ~/ 365}y';
  } else if (difference.inDays > 30) {
    return '${difference.inDays ~/ 30}mo';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return 'now';
  }
}
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  return token;
}
void _navigateToComments(BuildContext context) async {
  if (miniPost.id.isNotEmpty) { // Make sure the id is not an empty string
    PostHeader post = await ApiService().fetchPostByID(miniPost.id, await getToken()) ;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPostComments(postID: miniPost.id ),
      ),
    );
  } else {
    print('MiniPost id is an empty string');
  }
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToComments(context), // Use the _navigateToComments method here
      child: Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(miniPost.authorName[0].toUpperCase()),  // display the first letter of the author's name
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('r/${miniPost.subredditName}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      Text(formatDateTime(miniPost.createdAt), style: TextStyle(color: Colors.grey[600])),  // replace with your short time format
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(miniPost.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            Text('${miniPost.upvotes} upvotes • ${miniPost.comments} comments', style: TextStyle(color: Colors.grey[600])), // Change this line
          ],
        ),
      ),
    ),
    );
  }
}