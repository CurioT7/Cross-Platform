import 'package:flutter/material.dart';
import 'package:curio/utils/componentSelectionPopUPPage.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/Models/post.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class AllPage extends StatefulWidget {
  const AllPage({Key? key}) : super(key: key);

  @override
  State<AllPage> createState() => _AllPageState();
}

Future<double?> timeSelected = Future.value(0.0);

class _AllPageState extends State<AllPage> {
  String _selectedSort = 'hot';
  IconData _selectedIcon = Icons.whatshot;
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts(_selectedSort);
  }

  void _updateSortAndIcon(String newSort, IconData newIcon) {
    setState(() {
      _selectedSort = newSort;
      _selectedIcon = newIcon;
    });
    _fetchPosts(newSort); // Fetch posts based on the selected sorting criteria
  }

  Future<void> _fetchPosts(String sortCriteria) async {
    try {
      Map<String, dynamic> response;
      switch (sortCriteria) {
        case 'hot':
          response = await ApiServiceMahmoud().getHotPosts();
          print('fetching hot posts');
          break;
        case 'new':
          response = await ApiServiceMahmoud().getNewPosts();
          print('fetching new posts');
          break;
        case 'top All Time':
          response = await ApiServiceMahmoud().getTopAllTimePosts();
          print('fetching top All Time posts');
          break;
        case 'top This Year':
          response = await ApiServiceMahmoud().getTopThisYearPosts();
          print('fetching top This Year posts');
          break;
        case 'top This Month':
          response = await ApiServiceMahmoud().getTopThisMonthPosts();
          print('fetching top This Month posts');
          break;
        case 'top This Week':
          response = await ApiServiceMahmoud().getTopThisWeekPosts();
          print('fetching top This Week posts');
          break;
        case 'top Today':
          response = await ApiServiceMahmoud().getTopTodayPosts();
          print('fetching top Today posts');
          break;
        case 'top Now':
          response = await ApiServiceMahmoud().getTopNowPosts();
          print('fetching top Now posts');
          break;
        case 'rising':
          response = await ApiServiceMahmoud().getRisingPosts();
          print('fetching rising posts');
          break;
        case 'random':
          response = await ApiServiceMahmoud().getRandomPosts();
          print('fetching random posts');
          break;
        default:
          response = await ApiServiceMahmoud().getHotPosts();
          print('fetching hot posts default');
          break;
      }
      setState(() {
        _posts = (response['posts'] as List<dynamic>)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        _isLoading = false;
      });
      print(response['posts']); // Print fetched posts
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  void printPosts(List<dynamic> posts) {
    print('Fetched Posts:');
    for (var postJson in posts) {
      print(Post.fromJson(postJson));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xffF2F3F5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    timeSelected = showSortPostsBottomSheet(
                        context,
                        _selectedSort,
                        _selectedIcon,
                        _updateSortAndIcon,
                        _fetchPosts);
                  },
                  child: Row(
                    children: [
                      Icon(_selectedIcon),
                      Text(_selectedSort,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: _posts[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
