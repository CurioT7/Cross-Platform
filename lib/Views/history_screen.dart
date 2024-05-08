import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:curio/Models/post.dart';
import 'package:curio/widgets/postCard.dart';

import '../widgets/recent_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int votes = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> posts = [];

  void getHiddenPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
      await http.get(Uri.parse('http://localhost:3000/api/hidden'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          setState(() {
            posts = responseBody['hiddenPosts'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      log('Exception occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHiddenPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('History'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecentWidget(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return PostCard(
                  post: Post(
                    id: posts[index]['_id'],
                    title: posts[index]['title'],
                    content: posts[index]['content'],
                    authorName: posts[index]['authorName'],
                    views: posts[index]['views'],
                    createdAt: DateTime.parse(posts[index]['createdAt']),
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
    );
  }
}