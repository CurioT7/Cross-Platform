import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/minipost.dart';
import '../Models/t_post.dart';
import '../Models/user_search.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000/api';
  // final String baseUrl = 'http://192.168.1.13:3000/api';

  Future<List<MiniPost>> searchPost(String query) async {
    print('Search query: $query');
    final response = await http.get(Uri.parse('$baseUrl/search/$query'));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print('Response body: $responseBody');
      List<Map<String, dynamic>> postsData = responseBody['posts'] != null
          ? List<Map<String, dynamic>>.from(responseBody['posts'])
          : [];
      print('Posts: $postsData');
      List<MiniPost> posts =
          postsData.map((post) => MiniPost.fromJson(post)).toList();
      return posts;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<TPost>> getTrending() async {
    final url = Uri.parse('$baseUrl/trendingSearches');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          List<dynamic> trendingPostsJson = responseBody['posts'];
          log(trendingPostsJson.length.toString());
          return TPost.getTrendingPosts(trendingPostsJson);
        } else {
          throw Exception('Failed to load posts');
        }
      } else {
        throw Exception(
            'Failed to load Posts with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<List<UserSearch>> getUsers() async {
    final url = Uri.parse('$baseUrl/search/people/testUser');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          List<dynamic> usersJson = responseBody['users'];
          log(usersJson.length.toString());
          return UserSearch.getUsers(usersJson);
        } else {
          throw Exception('Failed to load users');
        }
      } else {
        throw Exception(
            'Failed to load users with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
