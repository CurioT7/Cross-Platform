import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class CommunitySearchPage extends SearchDelegate<String> {
  final ApiServiceMahmoud apiService = ApiServiceMahmoud();
  List<String> communities = [];
  List<String> recentCommunities = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for search bar
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results based on the search query
    return ListView.builder(
      itemCount: communities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(communities[index]),
          onTap: () {
            close(context, communities[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types in the search bar
    return ListView.builder(
      itemCount: recentCommunities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recentCommunities[index]),
          onTap: () {
            query = recentCommunities[index];
            showResults(context);
          },
        );
      },
    );
  }
  void searchCommunities(String query) async {
    try {
      final response = await apiService.searchCommunities(query);


      if (response.containsKey('success') && response['success'] == true) {
        List<dynamic> communityData = response['subreddits'];
        communities = communityData.map<String>((data) => data['name'] as String).toList();
      } else {
        communities = [];
      }
    } catch (e) {
      print('Error searching communities: $e');
      communities = [];
    }
  }

}
