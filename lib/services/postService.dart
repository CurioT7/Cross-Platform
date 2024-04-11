import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/Models/post.dart';
class ApiService {
  final String baseUrl = 'http://192.168.1.3:3000/api';

    Future<List<Post>> getBestPosts() async {
    try {
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
        throw Exception('Failed to load posts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
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

  Future<List<Post>> getDiscoveryPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/discovery'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          List<dynamic> postsJson = responseBody['DiscoveryPosts'];
          return postsJson.map((json) => Post.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load posts');
        }
      } else {
        throw Exception('Failed to load posts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<List<Post>> getPopularPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/popular'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          List<dynamic> postsJson = responseBody['PopularPosts'];
          return postsJson.map((json) => Post.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load posts');
        }
      } else {
        throw Exception('Failed to load posts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }
}


