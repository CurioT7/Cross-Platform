import 'package:flutter/material.dart';
import 'package:curio/widgets/schdueled_post_card.dart';

class ScheduledPostsPage extends StatelessWidget {
  late Map<String,dynamic> post;
  ScheduledPostsPage({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Posts'),
      ),
      body: Container(
        color: Colors.grey[200], // Set the background color to a little gray
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'SCHEDULED POSTS',
                style: TextStyle(
                  color: Colors.grey, // Set the title color to grey
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ScheduledPostCard(
              post: post,
            ),
          ],
        ),
      ),
    );
  }
}