import 'package:flutter/material.dart';
import 'package:curio/Models/minipost.dart';
import 'package:curio/Views/Search/searchHashtag.dart';
import 'package:curio/services/searchServices.dart';
import 'package:curio/widgets/miniPostCard.dart';
import 'package:curio/widgets/SortAndCommentList.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:curio/widgets/user_card.dart';
import 'package:curio/services/api_service.dart' as APIShams;


class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _searchService = ApiService();
  List<MiniPost> searchResults = [];
  List<String> suggestions = [];
  Map<String, dynamic> responseForCommunity = {};
  List<dynamic> responseForPeople = [];
  String dropdownValue = 'Hot';
  late TabController _tabController;
  ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _fetchUsers(String query) async{

      APIShams.ApiService apiService = APIShams.ApiService();
      await apiService.fetchUsers(query).then((value) {
        setState(() {
          responseForPeople = value;
        });
      });
  }
  void _fetchCommunities(String query) async {
    try {
      ApiServiceMahmoud apiService = ApiServiceMahmoud();
      Map<String, dynamic> response =
      await apiService.fetchCommunities(query);
      setState(() {
        responseForCommunity = response;
      });
      // print('User profile: $responseForCommunity');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> search(String query) async {
    try {
      // print('Search query: $query');
      searchQueryNotifier.value = query;
      // print("Search Query Notifier: ${searchQueryNotifier.value}");
      final List<MiniPost> results = await _searchService
          .searchPost(query); // Changed function name to searchPost

      // print('Posts: $results');

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No posts found for the given query')),
        );
      } else {
        setState(() {
          searchResults = results;
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No posts found for the given query')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _searchController.clear(),
            ),
            hintText: 'Search...',
          ),
          onChanged: (value) {},
          onSubmitted: (value) {
            _fetchCommunities(value);
            search(value);
            _fetchUsers(value);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          isScrollable: true,
          tabs: [
            Tab(text: 'Posts'),
            Tab(text: 'Communities'),
            Tab(text: 'People'),
            Tab(text: 'Comments'),
            Tab(text: 'Hashtags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return MiniPostCard(miniPost: searchResults[index]);
              },
            ),
          ),
          // Display communities
          ListView.builder(
            itemCount: responseForCommunity != null &&
                responseForCommunity!['subreddits'] != null
                ? responseForCommunity!['subreddits'].length
                : 1, // Display a placeholder item if subreddits are null
            itemBuilder: (context, index) {
              if (responseForCommunity == null ||
                  responseForCommunity!['subreddits'] == null) {
                return const ListTile(
                  title: Text('No communities found for the given query'),
                );
              } else {
                var subreddit = responseForCommunity!['subreddits'][index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset('lib/assets/images/Curio.png'),
                  ),
                  title: Text(subreddit['name']),
                  subtitle: Text('Members: ${subreddit['members']}'),
                  onTap: () {
                    // Add your code here for what should happen when the ListTile is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => communityProfile(communityName: subreddit['name']),
                      ),
                    );
                  },
                );
              }
            },
          ),
          // display people
          ListView.builder(
            itemCount: responseForPeople != null ? responseForPeople.length : 1,
            itemBuilder: (context, index) {
              if (responseForPeople == null || responseForPeople.isEmpty) {
                return const ListTile(
                  title: Text('No people found for the given query'),
                );
              } else {
                var user = responseForPeople[index];
                return UserCard(
                  userName: user['username'],
                  profilePic: user['profilePicture']?? 'https://cdn.fakercloud.com/avatars/doronmalki_128.jpg',
                  karma: user['karma'],
                );
              }
            },
          ),

          ValueListenableBuilder<String>(
            valueListenable: searchQueryNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return SortAndCommentList(
                query: value,
                sortOptions: const ['relevance', 'new','top'],
                onSortOptionSelected: (option) {},
              );
            },
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (BuildContext context, TextEditingValue value,
                Widget? child) {
              return Column(
                children: [
                  SearchHashtag(query: value.text),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
