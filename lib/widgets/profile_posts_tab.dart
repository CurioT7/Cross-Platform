import 'dart:convert';
import 'dart:developer';

import 'package:curio/Models/post.dart';
import 'package:curio/widgets/empty_widget.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePostsTab extends StatefulWidget {
  const ProfilePostsTab({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  State<ProfilePostsTab> createState() => _ProfilePostsTabState();
}

class _ProfilePostsTabState extends State<ProfilePostsTab> {
  List posts = [];
  // List<Map<String, dynamic>> comments = [];
  bool _isLoading = false;
  void getUserPosts() async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/user/${widget.userName}/overview');
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        setState(() {
          posts = responseBody['userPosts'];
          // comments = responseBody['userComments'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_isLoading,
      replacement: const Center(child: CircularProgressIndicator()),
      child: posts.isEmpty
          ? const EmptyWidget()
          : DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome),
                          SizedBox(width: 5.0),
                          Text('New Posts'),
                          SizedBox(width: 5.0),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(
                          post: Post(
                            id: posts[index]['_id'],
                            title: posts[index]['title'],
                            content: posts[index]['content'],
                            authorName: posts[index]['authorName'],
                            views: posts[index]['views'],
                            createdAt:
                                DateTime.parse(posts[index]['createdAt']),
                            upvotes: posts[index]['upvotes'],
                            downvotes: posts[index]['downvotes'],
                            linkedSubreddit: posts[index]['linkedSubreddit'],
                            comments: posts[index]['comments'],
                            shares: posts[index]['shares'],
                            isNSFW: posts[index]['isNSFW'],
                            isSpoiler: posts[index]['isSpoiler'],
                            isOC: posts[index]['isOC'],
                            isCrosspost: posts[index]['isCrosspost'],
                            awards: posts[index]['awards'],
                            media: '',
                            link: '',
                            isDraft: posts[index]['isDraft'],
                          ),
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
