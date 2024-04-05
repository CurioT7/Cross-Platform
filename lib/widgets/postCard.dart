import 'package:flutter/material.dart';
import 'package:curio/Models/post.dart';
import 'package:share/share.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int votes;

  @override
  void initState() {
    super.initState();
    votes = widget.post.upvotes - widget.post.downvotes;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.post.authorName), // Assuming authorName is a URL to the author's avatar
            ),
            title: Text(widget.post.title),
            subtitle: Text(widget.post.content),
          ),
          if (widget.post.media != null) // Assuming media is a URL to the post's image
            Image.network(
              widget.post.media!,
              errorBuilder: (context, error, stackTrace) {
                return Text('Could not load image.');
              },
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    setState(() {
                      votes++;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                  ),
                  child: Text('$votes'),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      votes--;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {},
                ),
                Spacer(), // Creates flexible space
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('Check out this post: ${widget.post.link}');
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