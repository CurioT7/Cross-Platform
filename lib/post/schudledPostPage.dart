import 'package:flutter/material.dart';
import 'package:curio/widgets/schdueled_post_card.dart';
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

  void removePost(Map<String, dynamic> updatedPost) {
    setState(() {
      scheduledPosts.remove(updatedPost);
    });
  }

  void submitPost(Map<String, dynamic> updatedPost) {
    removePost(updatedPost);
    // send the updated post to the API
    // just use the apiservice to submit a normal post.
  }

  Future<void> fetchScheduledPosts() async {
    // Add your API call here
    // TODO: Implement the API call to fetch scheduled posts
    // mock the api call with a delay
    setState(() {
      showPostCard = true;
    });
    print("Fetching scheduled posts");
    print(widget.post);
    if (widget.post.isNotEmpty && !scheduledPosts.contains(widget.post)) {
      var post = widget.post;
      post['title'] = post['title'] + ' [Updated]';
      // change the post some data to make it different
      scheduledPosts.add(post);

      post['title'] = post['title'] + ' [Updated]';
      scheduledPosts.add(post);
      scheduledPosts.add(widget.post);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchScheduledPosts(),
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
