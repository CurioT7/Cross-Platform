import 'package:curio/Models/minipost.dart';
import 'package:curio/services/searchServices.dart';
import 'package:curio/widgets/miniPostCard.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _searchService = ApiService();
  List<MiniPost> searchResults = [];
  List<String> suggestions = [];
  String dropdownValue = 'Hot';
  late TabController _tabController;

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

  Future<void> search(String query) async {
    try {
      print('Search query: $query');
      final List<MiniPost> results = await _searchService.searchPost(query); // Changed function name to searchPost
      print('Posts: $results');
  
      // Assign results to searchResults
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error: $e');
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
          onChanged: (value) {
           // getSuggestions(value);
          },
          onSubmitted: (value) {
            search(value);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black, // Set the color of the selected tab
          labelStyle: TextStyle(fontWeight: FontWeight.bold), // Set the text style of the selected tab
          unselectedLabelColor: Colors.grey, // Set the color of the unselected tabs
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Set the text style of the unselected tabs
          isScrollable: true,
          tabs: [
            Tab(text: 'Posts'),
            Tab(text: 'Communities'),
            Tab(text: 'Comments'),
            Tab(text: 'Media'),
            Tab(text: 'People'),
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
          // Replace these with your actual widgets for displaying the search results
          Container(child: Center(child: Text('Communities'))),
          Container(child: Center(child: Text('Comments'))),
          Container(child: Center(child: Text('Media'))),
          Container(child: Center(child: Text('People'))),
        ],
      ),
    );
  }
}