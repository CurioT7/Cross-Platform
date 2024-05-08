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
            future: Future.wait([
              if (commentsFuture != null) commentsFuture!,
              if (postsFuture != null) postsFuture!,
            ]), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var allData = [];
                if (snapshot.data != null) {
                  allData = [...snapshot.data![0], ...snapshot.data![1]];
                }
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width*0.99,
                    height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
                    child: ListView.builder(
                      itemCount: allData.length,
                      itemBuilder: (context, index) {
                        var data = allData[index];
                        if (data is MiniPost) {
                          try {
                            return MiniPostCard(miniPost: data);
                          } catch (e) {
                            print('Error building MiniPostCard: $e');
                            return Container();
                          }
                        } else {
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
                        }
                      },
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}