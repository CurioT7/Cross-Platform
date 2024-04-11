import 'package:flutter/material.dart';
import 'package:curio/Models/post.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/utils/reddit_colors.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isModerator;

  const PostCard({Key? key, required this.post, this.isModerator=false} ) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int votes;
  bool upvoted = false;
  bool downvoted = false;

  @override
  void initState() {
    super.initState();
    votes = widget.post.upvotes - widget.post.downvotes;
  }

  void _upvote() {
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
    // TODO: Implement the logic to send the upvote to your backend or state management system
  }

  void _downvote() {
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
    // TODO: Implement the logic to send the downvote to your backend or state management system
  }

  void _navigateToComments() {
    // TODO: Implement navigation logic to comments screen
  }

  void _sharePost() {
    try {
      Share.share('Check out this post on Reddit: ${widget.post.title}');
    } catch (e) {
      // Handle the exception
      print('An error occurred while sharing the post: $e');
    }
  }
  void _moderatorAction() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.warning_amber_rounded),
                title: Text('Mark Spoiler'),
                onTap: () {
                  // TODO: Implement the logic for marking as spoiler
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Lock Comments'),
                onTap: () {
                  // TODO: Implement the logic for locking comments
                },
              ),
              ListTile(
                leading: Icon(Icons.push_pin),
                title: Text('Sticky Post'),
                onTap: () {
                  // TODO: Implement the logic for making post sticky
                },
              ),
              ListTile(
                leading: Icon(Icons.eighteen_up_rating),
                title: Text('Mark NSFW'),
                onTap: () {
                  // TODO: Implement the logic for marking as NSFW
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove Post'),
                onTap: () {
                  // TODO: Implement the logic for removing post
                },
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Approve Post'),
                onTap: () {
                  // TODO: Implement the logic for approving post
                },
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
Widget _buildPostIcons() {
  List<Widget> icons = [];

  if (widget.post.isNSFW) {
    icons.add(const Row(
      children: [
        Icon(Icons.eighteen_up_rating, color: Colors.pinkAccent),
        Text(' NSFW', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)), 
             ],
    ));
  }
  if (widget.post.isSpoiler) {
    icons.add(const Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.black),
        Text(' SPOLIER',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    ));
  }
  // if (widget.post.isOC) {
  //   icons.add(Row(
  //     children: [
  //       const Icon(Icons.star, color: Colors.yellow),
  //       const Text(' OC'),
  //     ],
  //   ));
  // }
  // if (widget.post.isCrosspost) {
  //   icons.add(Row(
  //     children: [
  //       const Icon(Icons.share, color: Colors.blue),
  //       const Text(' Crosspost'),
  //     ],
  //   ));
  // }

  if (icons.isEmpty) {
    return Container();
  }

  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Row(children: icons),
  );
}
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://www.redditstatic.com/avatars/avatar_default_13_46D160.png'),
            ),
            title: Text('r/${widget.post.linkedSubreddit}'),
            subtitle: Text('u/${widget.post.authorName} • ${timeago.format(widget.post.createdAt)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _buildPostIcons(),
          if (widget.post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(widget.post.content),
            ),
          if (widget.post.media != null)
            Image.network(
              widget.post.media,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                // You can return any widget here. For instance, return an empty Container.
                return Container();
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(const IconData(0xe800, fontFamily: 'MyFlutterApp'), color: upvoted ? redditUpvoteOrange : Colors.grey),
                onPressed: _upvote,
              ),
              Text('$votes', style: TextStyle(color: upvoted ? redditUpvoteOrange : downvoted ? redditDownvoteBlue : Colors.grey)),
              IconButton(
                icon: Icon(const IconData(0xe801, fontFamily: 'MyFlutterApp'), color: downvoted ? redditDownvoteBlue : Colors.grey),
                onPressed: _downvote,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: _navigateToComments,
              ),
              Text('${widget.post.comments.length}'),
              if (widget.isModerator) 
                IconButton(
                  icon: const Icon(Icons.shield),
                  onPressed: _moderatorAction,
                )
              else ...[
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _sharePost,
                ),
                Text('${widget.post.shares}'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
