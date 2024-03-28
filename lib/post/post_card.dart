import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String content;
  final int? upvotes;
  final int? comments;
  final int? downvotes;
  final int? shares;
  final String? username;
  final String? postTime;
  final String? userImage;
  final String? postImage;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
    this.upvotes,
    this.comments,
    this.downvotes,
    this.shares,
    this.username,
    this.postTime,
    this.userImage,
    this.postImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: userImage != null ? NetworkImage(userImage!) : null,
              ),
              title: Text(username ?? 'Unknown'),
              subtitle: Text(postTime ?? 'Unknown time'),
              trailing: const Icon(Icons.more_vert),
            ),
            if (postImage != null)
              Image.network(
                postImage!,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {},
                ),
                Text('${upvotes ?? 0}'),
                IconButton(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () {},
                ),
                Text('${downvotes ?? 0}'),
                IconButton(
                  icon:const  Icon(Icons.comment),
                  onPressed: () {},
                ),
                Text('${comments ?? 0}'),
                IconButton(
                  icon:const  Icon(Icons.share),
                  onPressed: () {},
                ),
                Text('${shares ?? 0}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}