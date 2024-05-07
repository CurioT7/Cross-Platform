import 'package:curio/widgets/searchCommentCard.dart';
import 'package:flutter/material.dart';
import 'package:curio/widgets/SortByButton.dart';
import 'package:curio/services/api_service.dart';

class SortAndCommentList extends StatefulWidget {
  final List<String> sortOptions;
  final String query;
  final Function(String) onSortOptionSelected;

  const SortAndCommentList({
    super.key,
    required this.query,
    required this.sortOptions,
    required this.onSortOptionSelected,
  });

  @override
  _SortAndCommentListState createState() => _SortAndCommentListState();
}

class _SortAndCommentListState extends State<SortAndCommentList> {
  Future<List<dynamic>>? commentsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    commentsFuture = _apiService.fetchComments({
      'query': widget.query,
      'sortOption': widget.sortOptions[0],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SortOptionsDialog(
            options: widget.sortOptions,
            onOptionSelected: (option) {
              setState(() {
                commentsFuture = _apiService.fetchComments({
                  'query': widget.query,
                  'sortOption': option,
                });
              });
              widget.onSortOptionSelected(option);
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: commentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data != null
                    ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return SearchCommentCard(
                      communityImage: "assets/images/loft.png",
                      communityName: data['linkedSubreddit'] != null
                          ? data['linkedSubreddit']['name']
                          : 'Unknown',
                      postCreatedAt: data['linkedPost']['createdAt'],
                      commentCreatedAt: data['createdAt'],
                      userName: data['authorName'],
                      postTitle: data['linkedPost']['title'],
                      commentContent: data['content'],
                      postUpvotes: data['linkedPost']['upvotes'],
                      commentUpvotes: data['upvotes'],
                      numberOfComments:
                      data['linkedPost']['comments']!.length,
                      postID: data['linkedPost']['_id'],
                    );
                  },
                )
                    : Container();
              }
            },
          ),
        ),
      ],
    );
  }
}