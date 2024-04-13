import 'dart:async';

import 'package:curio/Views/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/post.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/utils/reddit_colors.dart';

import '../controller/report/report_cubit.dart';
import 'report_user_or_post_bottom_sheet.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isModerator;

  const PostCard({super.key, required this.post, this.isModerator = false});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int votes;
  bool upvoted = false;
  bool downvoted = false;
  bool _isVisible = true;
  bool _canUnhide = true;

  @override
  void initState() {
    super.initState();
    votes = widget.post.upvotes - widget.post.downvotes;
  }

  void _toggleVisibility() {
    if (_isVisible || _canUnhide) {
      setState(() {
        _isVisible = !_isVisible;
      });

      if (!_isVisible) {
        Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _canUnhide = false;
            });
          }
        });
      }
    }
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
                leading: const Icon(Icons.warning_amber_rounded),
                title: const Text('Mark Spoiler'),
                onTap: () {
                  // TODO: Implement the logic for marking as spoiler
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Lock Comments'),
                onTap: () {
                  // TODO: Implement the logic for locking comments
                },
              ),
              ListTile(
                leading: const Icon(Icons.push_pin),
                title: const Text('Sticky Post'),
                onTap: () {
                  // TODO: Implement the logic for making post sticky
                },
              ),
              ListTile(
                leading: const Icon(Icons.eighteen_up_rating),
                title: const Text('Mark NSFW'),
                onTap: () {
                  // TODO: Implement the logic for marking as NSFW
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Post'),
                onTap: () {
                  // TODO: Implement the logic for removing post
                },
              ),
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('Approve Post'),
                onTap: () {
                  // TODO: Implement the logic for approving post
                },
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('Close',
                      style: TextStyle(color: Colors.white)),
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
      icons.add(
        const Row(
          children: [
            Icon(Icons.eighteen_up_rating, color: Colors.pinkAccent),
            Text(
              ' NSFW',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (widget.post.isSpoiler) {
      icons.add(const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.black),
          Text(
            ' SPOLIER',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    }
    if (widget.post.isOC) {
      icons.add(const Row(
        children: [
          Icon(Icons.star, color: Colors.yellow),
          Text(
            ' OC',
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    }
    if (widget.post.isCrosspost) {
      icons.add(const Row(
        children: [
          Icon(Icons.share, color: Colors.blue),
          Text(
            ' Crosspost',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    }

    if (icons.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(children: icons),
    );
  }

  void _additionalOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save'),
              onTap: () {
                // TODO: Implement the logic for saving the post
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: const Text('Hide'),
              onTap: () {
                _toggleVisibility();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAlias,
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => ReportCubit(),
                      child: ReportUserOrPostBottomSheet(id: widget.post.id),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block Account'),
              onTap: () {
                // TODO: Implement the logic for blocking the account
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Text'),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: widget.post.content ?? ""));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Crosspost to Community'),
              onTap: () {
                // TODO: Implement the logic for crossposting to community
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                // TODO: Implement the logic for downloading the post
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_canUnhide) {
      return Container();
    } else if (!_isVisible) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.visibility),
          title: const Text('Post hidden'),
          trailing: IconButton(
            icon: const Icon(Icons.visibility_off),
            onPressed: _toggleVisibility,
          ),
        ),
      );
    }
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfileScreen(
                    isUser: true,
                    userName: widget.post.authorName,
                    days: widget.post.createdAt.day,
                    // userDetails: {
                    //   'profilePicture': widget.post.media,
                    //   'postKarma': widget.post.awards.toString(),
                    // },
                  ),
                ),
              );
            },
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.redditstatic.com/avatars/avatar_default_13_46D160.png',
              ),
            ),
            title: Text('r/${widget.post.linkedSubreddit}'),
            subtitle: Text(
                'u/${widget.post.authorName} • ${timeago.format(widget.post.createdAt)}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _additionalOptions,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.post.title ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _buildPostIcons(),
          // For the content field
          if (widget.post.content != null && widget.post.content!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(widget.post.content!),
            ),

          // For the media field
          if (widget.post.media != null && widget.post.media!.isNotEmpty)
            Image.network(
              widget.post.media!,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(); // Return an empty container if the image fails to load
              },
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(const IconData(0xe800, fontFamily: 'MyFlutterApp'),
                    color: upvoted ? redditUpvoteOrange : Colors.grey),
                onPressed: _upvote,
              ),
              Text('$votes',
                  style: TextStyle(
                      color: upvoted
                          ? redditUpvoteOrange
                          : downvoted
                              ? redditDownvoteBlue
                              : Colors.grey)),
              IconButton(
                icon: Icon(const IconData(0xe801, fontFamily: 'MyFlutterApp'),
                    color: downvoted ? redditDownvoteBlue : Colors.grey),
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
