import 'dart:async';
import 'package:curio/services/logicAPI.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curio/Views/my_profile_screen.dart';
import 'package:curio/services/postService.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/post.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/utils/reddit_colors.dart';
import '../controller/report/report_cubit.dart';
import '../post/screen_post.dart';
import 'report_user_or_post_bottom_sheet.dart';
import 'package:curio/comment/viewPostComments.dart';
import 'package:curio/Views/share/shareToProfile.dart';
import 'package:curio/Views/community/chooseCommunity.dart';
import 'join_button.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isModerator;
  final bool isMyPost;
  final String communityName;


  const PostCard({super.key, required this.post, this.isModerator = false,  this.isMyPost=false, this.communityName=''});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  late int votes;
  bool upvoted = false;
  bool downvoted = false;
  bool _isVisible = true;
  bool _canUnhide = true;
  SharedPreferences? prefs;
  String voteStatus = 'neutral';
  String image = 'https://www.redditstatic.com/avatars/avatar_default_13_46D160.png';
  bool isInSubreddit =true;

  @override
  bool get wantKeepAlive => true; // Add this line

  @override
  void initState() {
    super.initState();
    fetchAndSetUserImage();
    votes = widget.post.upvotes - widget.post.downvotes;
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      setState(() {
        voteStatus = prefs?.getString(widget.post.id) ?? 'neutral';
        upvoted = voteStatus == 'upvoted';
        downvoted = voteStatus == 'downvoted';
      });
    });
  }

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  return token;
}
void fetchAndSetUserImage() async {
    logicAPI api = logicAPI();
    Map<String, dynamic> userData = await api.fetchUserData(widget.post.authorName?? 'default');
    Map<String, dynamic> userDetails = await api.extractUserDetails(userData);
    setState(() {
      image = userDetails['profilePicture'];
      print("image link: $image");
    });
  }

  void _toggleVisibility() async {
    if (_isVisible || _canUnhide) {
      String token = await getToken();
      if (_isVisible) {
        bool hideResult = await ApiService().hidePost(widget.post.id, token);
        if (hideResult) {
          setState(() {
            _isVisible = !_isVisible;
          });
          Timer(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _canUnhide = false;
              });
            }
          });
        } else {
          print('Failed to hide post');
        }
      } else {
        bool unhideResult =
            await ApiService().unhidePost(widget.post.id, token);
        if (unhideResult) {
          setState(() {
            _isVisible = !_isVisible;
          });
        } else {
          print('Failed to unhide post');
        }
      }
    }
  }

  Future<void> _upvote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

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

    // Save vote status to SharedPreferences
    prefs.setString(widget.post.id, upvoted ? 'upvoted' : 'neutral');

    int direction = upvoted ? 1 : 0;
    ApiService().castVote(widget.post.id, direction, token);
  }

  Future<void> _downvote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

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

    // Save vote status to SharedPreferences
    prefs.setString(widget.post.id, downvoted ? 'downvoted' : 'neutral');

    int direction = downvoted ? -1 : 0;
    ApiService().castVote(widget.post.id, direction, token);
  }

  void _navigateToComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPostComments(postID: widget.post.id),
      ),
    );
  }

  void _sharePost() {
    try {
      Share.share('Check out this post on Reddit: ${widget.post.title}');
    } catch (e) {
      // Handle the exception
      print('An error occurred while sharing the post: $e');
    }
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open link')),
      );
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
                title: Text(
                    widget.post.isSpoiler ? 'Unmark Spoiler' : 'Mark Spoiler'),
                onTap: () async {
                  String token = await getToken();
                  String message;
                  if (widget.post.isSpoiler) {
                    await ApiService().unspoilPost(widget.post.id, token);
                    message = 'Post has been unmarked as spoiler';
                  } else {
                    await ApiService().spoilPost(widget.post.id, token);
                    message = 'Post has been marked as spoiler';
                  }
                  setState(() {
                    widget.post.isSpoiler = !widget.post.isSpoiler;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(
                    widget.post.isLocked ? 'Unlock Comments' : 'Lock Comments'),
                onTap: () async {
                  String token = await getToken();
                  String message;
                  if (widget.post.isLocked) {
                    await ApiService().unlockPost(widget.post.id, token);
                    message = 'Comments have been unlocked';
                  } else {
                    await ApiService().lockPost(widget.post.id, token);
                    message = 'Comments have been locked';
                  }
                  setState(() {
                    widget.post.isLocked = !widget.post.isLocked;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.eighteen_up_rating),
                title: Text(widget.post.isNSFW ? 'Unmark NSFW' : 'Mark NSFW'),
                onTap: () async {
                  String token = await getToken();
                  String message;
                  if (widget.post.isNSFW) {
                    await ApiService().unmarkAsNsfw(widget.post.id, token);
                    message = 'Post has been unmarked as NSFW';
                  } else {
                    await ApiService().markAsNsfw(widget.post.id, token);
                    message = 'Post has been marked as NSFW';
                  }
                  setState(() {
                    widget.post.isNSFW = !widget.post.isNSFW;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Post'),
                onTap: () async {
                  try {
                    String token = await getToken();
                    await ApiService().removePost(widget.post.id, 'post', widget.communityName,token);
                    // Update the UI after the post is removed
                    setState(() {
                      // Remove the post from your data source
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post removed successfully')),
                    );
                  } catch (e) {
                    // Handle the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to remove post: $e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('Approve Post'),
                onTap: () async {
                  try {
                    String token = await getToken();
                    ApiService apiService = ApiService();
                    await apiService.approvePost(widget.post.id, 'post', widget.post.subredditName, token);
                    // Update the UI after the post is approved
                    setState(() {
                      // Update the post in your data source
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post approved successfully')),
                    );
                  } catch (e) {
                    // Handle the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to approve post: $e')),
                    );
                  }
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
              ' NSFW ',
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
            ' SPOLIER ',
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
            ' OC ',
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
            ' Crosspost ',
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
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.save),
              title: Text(widget.post.isSaved ? 'Unsave' : 'Save'),
              onTap: () async {
                String token = await getToken();
                if (widget.post.isSaved) {
                  await ApiService().unsavePost(widget.post.id, token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have unsaved this post.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  await ApiService().savePost(widget.post.id, token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have saved this post.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                setState(() {
                  widget.post.isSaved = !widget.post.isSaved;
                });
                Navigator.pop(context); // Close the options menu
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
              leading: const Icon(Icons.copy),
              title: const Text('Copy Text'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.post.content));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Crosspost to Community'),
              onTap: () {
                print('this is the crosspost to community page');
                print('widget.post.id' + widget.post.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChooseCommunityPage(oldPostId: widget.post.id)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Share to profile'),
              onTap: () {
                print('this is the share to profile page');
                print('widget.post.id' + widget.post.id);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareToProfilePage(
                            oldPostId: widget.post.id,
                          )),
                );
              },
            ),
            if (true) ...[
              // Check if it's the user's post
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPostScreen(
                        post: widget.post.toJson(),
                        type: 'text',
                        editingPost: true,
                        canChooseCommunity: false,
                        subreddit: {'subreddit': widget.post.subredditName},
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  try {
                    var postId = widget.post.id; // Replace with your post id
                    var token = 'your_token'; // Replace with your token
                    var response = await ApiService().deletePost(postId, token);

                    if (response['success']) {
                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    } else {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete post')),
                      );
                    }
                  } catch (e) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete post')),
                    );
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfileScreen(
                    isUser: true,
                    userName: widget.post.authorName,
                    days: widget.post.createdAt.day,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(image),
            ),
            title: Text(
              'r/${widget.post.subredditName}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Text(
              'u/${widget.post.authorName} • ${timeago.format(widget.post.createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize:
                  MainAxisSize.min, // set to minimum to prevent overflow
              children: [
                JoinButton(
                  isUserMemberOfItemSubreddit:
                      widget.post.isUserMemberOfItemSubreddit,
                  communityName: widget.post.subredditName,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: _additionalOptions,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewPostComments(postID: widget.post.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.post.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  if (widget.post.isLocked)
                    const Icon(Icons.lock, color: Color(0xFFD4AF37)),
                  if (widget.post.link != null && widget.post.link!.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.link, color: Colors.blue),
                      onPressed: () => _launchURL(widget.post.link!),
                    ),
                ],
              ),
            ),
          ),
          _buildPostIcons(),
          if (widget.post.content != null && widget.post.content!.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewPostComments(postID: widget.post.id),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(widget.post.content,
                    style: const TextStyle(color: Colors.black)),
              ),
            ),
          if (widget.post.media != null && widget.post.media!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.post.media!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Return an empty Container when image fails to load
                  return Container();
                },
              ),
            ),
            if (widget.post.options != null && widget.post.options.isNotEmpty)
              Column(
                children: widget.post.options.map((option) {
                  return ListTile(
                    title: Text(option),
                    trailing: IconButton(
                      icon: Icon(Icons.radio_button_unchecked),
                      onPressed: () {
                        // Handle poll option selection
                      },
                    ),
                  );
                }).toList(),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  onPressed: _navigateToComments,
                ),
                Text('${widget.post.comments.length}',
                    style: const TextStyle(color: Colors.grey)),
                if (widget.isModerator)
                  IconButton(
                    icon: const Icon(Icons.shield_outlined, color: Colors.grey),
                    onPressed: _moderatorAction,
                  )
                else ...[
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.grey),
                    onPressed: _sharePost,
                  ),
                  Text('${widget.post.shares}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
