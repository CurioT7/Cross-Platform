import 'dart:io';

import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:curio/widgets/schdueled_post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen_post.dart';

class ScheduledPostsPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final Map<String, dynamic> community;
  ScheduledPostsPage(
      {Key? key, this.post = const {}, this.community = const {}})
      : super(key: key);

  @override
  _ScheduledPostsPageState createState() => _ScheduledPostsPageState();
}

class _ScheduledPostsPageState extends State<ScheduledPostsPage> {
  bool showPostCard = true;
  List<Map<String, dynamic>> scheduledPosts = [];
  late Future<void> fetchPostsFuture;

  void removePost(Map<String, dynamic> updatedPost) async {
    try {
      bool isDeleted = await ApiService().deleteScheduledPost(updatedPost['_id']);
      if (isDeleted) {
        setState(() {
          scheduledPosts.remove(updatedPost);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete post: $e',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> submitPost(Map<String, dynamic> updatedPost, String subreddit) async {
    Map<String,dynamic> post = {
      'title': updatedPost['title'],
      'content': updatedPost['content'],
      'type': updatedPost['type'],
      'isNSFW': updatedPost['isNSFW'],
      'isSpoiler': updatedPost['isSpoiler'],
      'isOC': updatedPost['isOC'],
      'subreddit': subreddit,
      'media': updatedPost['media']??'',
      'options': updatedPost['options']??'',
      'voteLength': updatedPost['voteLength']??0,
    };
    File? image;
    File? video;
    // check if the post['media'] is an ImageComponent
    if (post['media'] is ImageComponent) {
      image = post['media'].image;
    }
    else if (post['media'] is VideoComponent) {
      video = post['media'].video;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    var media = post['type'] == 'media' ? image ?? video : null;
    final response = await ApiService().submitPost(post, token, media);
    if (response['success'] == true) {
      removePost(updatedPost);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> fetchScheduledPosts() async {
    // Add your API call here
    var posts = await ApiService()
        .fetchScheduledPosts(widget.community['subreddit'].name);
    scheduledPosts = List<Map<String, dynamic>>.from(posts);
    // mock the api call with a delay
    setState(() {
      showPostCard = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPostsFuture = fetchScheduledPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPostsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error fetching posts'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Scheduled Posts'),
              ),
              body: Container(
                color: Colors.grey[200],
                child: scheduledPosts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "There aren't any scheduled posts",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              child: const Text('Schedule Post'),
                              onPressed: () {
                                // Navigate to the Schedule Post screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPostScreen(
                                      post: {},
                                      type: 'text',
                                      isScheduled: true,
                                      subreddit: widget.community,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'SCHEDULED POSTS',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: scheduledPosts.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Visibility(
                                      visible: showPostCard,
                                      child: ScheduledPostCard(
                                        post: scheduledPosts[index],
                                        community:
                                            widget.community['subreddit'] ?? {},
                                        updatePost: removePost,
                                        submitPost: submitPost,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
        }
      },
    );
  }
}
