import 'package:curio/Models/minipost.dart';
import 'package:curio/Models/t_post.dart';
import 'package:curio/services/searchServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/search_cubit/search_cubit.dart';
import '../../widgets/miniPostCard.dart';
import '../../widgets/search_user_list_view.dart';
import '../../widgets/trending_posts_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _searchService = ApiService();
  List<MiniPost> searchResults = [];
  List<String> suggestions = [];
  List<TPost> trending = [];
  String dropdownValue = 'Hot';
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getTrending();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    try {
      print('Search query: $query');
      final List<MiniPost> results = await _searchService
          .searchPost(query); // Changed function name to searchPost
      print('Posts: $results');

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No posts found for the given query')),
        );
      } else {
        // Assign results to searchResults
        setState(() {
          searchResults = results;
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No posts found for the given query')),
      );
    }
  }

  Future<void> getTrending() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<TPost> results = await _searchService.getTrending();
      // Changed function name to searchPost
      print('Posts: $results');

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No trending posts found')),
        );
      } else {
        // Assign results to searchResults
        setState(() {
          trending = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final SearchCubit searchCubit = context.read<SearchCubit>();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (searchCubit.currentPage == 1) {
                    searchCubit.changeCurrentPage(0);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30.0,
                ),
              ),
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _searchController.clear(),
                  ),
                  hintText: 'Search...',
                ),
                onChanged: (value) {
                  // getSuggestions(value);
                },
                onSubmitted: (value) {
                  search(value);
                },
              ),
              bottom: searchCubit.currentPage == 1
                  ? TabBar(
                      controller: _tabController,
                      labelColor:
                          Colors.black, // Set the color of the selected tab
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight
                              .bold), // Set the text style of the selected tab
                      unselectedLabelColor:
                          Colors.grey, // Set the color of the unselected tabs
                      unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight
                              .normal), // Set the text style of the unselected tabs
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Communities'),
                        Tab(text: 'Comments'),
                        Tab(text: 'Media'),
                        Tab(text: 'People'),
                      ],
                    )
                  : null,
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : trending.isNotEmpty && searchCubit.currentPage == 0
                    ? TrendingPostsWidget(posts: trending)
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                return MiniPostCard(
                                  miniPost: searchResults[index],
                                );
                              },
                            ),
                          ),
                          // Replace these with your actual widgets for displaying the search results
                          const Center(child: Text('Communities')),
                          const Center(child: Text('Comments')),
                          const Center(child: Text('Media')),
                          const Expanded(
                            child: SearchUserListView(),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
