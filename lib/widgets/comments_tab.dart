import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/comment_model.dart';
import 'empty_widget.dart';

class CommentsTab extends StatefulWidget {
  const CommentsTab({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  List<CommentModel> comments = [];
  // List<Map<String, dynamic>> comments = [];
  bool _isLoading = false;
  void getUserComments() async {
    final url =
    Uri.parse('http://10.0.2.2:3000/api/user/${widget.userName}/overview');
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        for (var comment in responseBody['userComments']) {
          comments.add(CommentModel.fromJson(comment));
        }
        setState(() {
          comments = comments;
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
    getUserComments();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_isLoading,
      replacement: const Center(child: CircularProgressIndicator()),
      child: comments.isEmpty
          ? const EmptyWidget()
          : ListView.separated(
        itemCount: comments.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade200),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments[index].authorName ?? 'Null',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  comments[index].content ?? 'Null',
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
