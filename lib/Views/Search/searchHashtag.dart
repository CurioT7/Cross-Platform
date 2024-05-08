import 'package:curio/Models/minipost.dart';
import 'package:curio/widgets/searchCommentCard.dart';
import 'package:flutter/material.dart';
import 'package:curio/services/logicAPI.dart';

import '../../widgets/miniPostCard.dart'; // Replace with the correct path to your logicAPI file

class SearchHashtag extends StatefulWidget {
  final String query;

  const SearchHashtag({
    super.key,
    required this.query,
  });

  @override
  _SearchHashtagState createState() => _SearchHashtagState();
}

class _SearchHashtagState extends State<SearchHashtag> {
  Future<List<dynamic>>? commentsFuture;
  Future<List<MiniPost>>? postsFuture;
  final logicAPI _logicAPI = logicAPI(); // Replace with the correct class name from your logicAPI file

  @override
  void initState() {
    super.initState();
    commentsFuture = _logicAPI.fetchHashtagResultsComments(widget.query);
    postsFuture = _logicAPI.fetchHashtagResultsPosts(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          FutureBuilder<List<dynamic>>(
            future: commentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data != null ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return SearchCommentCard(
                      communityImage: "assets/images/loft.png",
                      communityName: data['linkedSubreddit'],
                      postCreatedAt: data['postCreatedAt'],
                      commentCreatedAt: data['createdAt'],
                      userName: data['authorName'],
                      postTitle: data['linkedPostTitle'],
                      commentContent: data['content'],
                      postUpvotes: data['linkedPostNumUpvotes'],
                      commentUpvotes: data['upvotes'],
                      numberOfComments: data['linkedPostNumComments'],
                      postID: data['linkedPostId'],
                    );
                  },
                ) : Container();
              }
            },
          ),
          FutureBuilder<List<MiniPost>>(
            future: postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data != null ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MiniPostCard(miniPost: snapshot.data![index]);
                  },
                ) : Container();
              }
            },
          ),
        ],
      ),
    );
  }
}