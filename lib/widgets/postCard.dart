import 'package:flutter/material.dart';
import 'package:curio/Models/post.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/utils/reddit_colors.dart';


class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int votes;
  bool upvoted = false; // Track if the user has upvoted
  bool downvoted = false; // Track if the user has downvoted

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
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://www.redditstatic.com/avatars/avatar_default_13_46D160.png'),
            ),
            title: Text(widget.post.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('r/${widget.post.linkedSubreddit} • u/${widget.post.authorName} • ${timeago.format(widget.post.createdAt)}'), // Display subreddit name, author name, and creation time in the same line
                if (widget.post.isNSFW) Icon(Icons.warning), // Display an icon if the post is NSFW
                if (widget.post.isSpoiler) Icon(Icons.visibility_off), // Display an icon if the post is a spoiler
                if (widget.post.isOC) Icon(Icons.star), // Display an icon if the post is OC
                if (widget.post.isCrosspost) Icon(Icons.share), // Display an icon if the post is a crosspost
                Text(widget.post.content),
              ],
            ),
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
                Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black), // Add a black border
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_upward, color: upvoted ? redditUpvoteOrange : Colors.grey), // Change the upvote color
                        onPressed: () {
                          setState(() {
                            if (!upvoted) {
                              votes++;
                              upvoted = true;
                              if (downvoted) {
                                votes++;
                                downvoted = false;
                              }
                            } else {
                              votes--;
                              upvoted = false;
                            }
                          });
                        },
                      ),
                      Text('$votes', style: TextStyle(color: upvoted ? redditUpvoteOrange : downvoted ? redditDownvoteBlue : Colors.grey)),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, color: downvoted ? redditDownvoteBlue : Colors.grey), // Change the downvote color
                        onPressed: () {
                          setState(() {
                            if (!downvoted) {
                              votes--;
                              downvoted = true;
                              if (upvoted) {
                                votes--;
                                upvoted = false;
                              }
                            } else {
                              votes++;
                              downvoted = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded( // Use Expanded to prevent overflow
                  child: GestureDetector(
                    onTap: () {
                      // Perform your action here
                    },
                    child: Row(
                      children: [
                        Icon(Icons.comment), // Add the comments icon
                        Text('${widget.post.comments.length} comments'),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {// Share the post title and content using the Share plugin
                    Share.share('Check out this post: ${widget.post.title}\n${widget.post.content}');
                  },  
                ),
                Text('${widget.post.shares}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}