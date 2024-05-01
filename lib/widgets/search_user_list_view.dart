import 'package:flutter/material.dart';

import '../Models/t_post.dart';
import '../Models/user_search.dart';
import '../services/searchServices.dart';
import 'search_user_item.dart';

class SearchUserListView extends StatefulWidget {
  const SearchUserListView({
    super.key,
  });

  @override
  State<SearchUserListView> createState() => _SearchUserListViewState();
}

class _SearchUserListViewState extends State<SearchUserListView> {
  final ApiService _searchService = ApiService();
  bool _isLoading = false;
  List<UserSearch> users = [];

  Future<void> getUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<UserSearch> results = await _searchService.getUsers();
      // Changed function name to searchPost
      print('Users: $results');

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Users found')),
        );
      } else {
        // Assign results to searchResults
        setState(() {
          users = results;
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
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_isLoading,
      replacement: const Center(child: CircularProgressIndicator()),
      child: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          return UserSearchWidget(user: users[index]);
        },
      ),
    );
  }
}
