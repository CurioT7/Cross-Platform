import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/models/post.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000/api';
  int _page = 0;

  Future<List<Post>> getBestPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/best'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<dynamic> postsJson = responseBody['SortedPosts'];
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> getRandomPost(String subreddit) async {
    final response = await http.get(Uri.parse('$baseUrl/r/$subreddit/random'));
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}