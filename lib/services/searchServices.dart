import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/Models/minipost.dart';

class ApiService{
  final String baseUrl = 'http://192.168.1.13:3000/api';
  
  Future<List<MiniPost>> searchPost(String query) async {
    print('Search query: $query');
    final response = await http.get(Uri.parse('$baseUrl/search/$query'));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print('Response body: $responseBody');
      List<Map<String, dynamic>> postsData = responseBody['posts'] != null ? List<Map<String, dynamic>>.from(responseBody['posts']) : [];
      print('Posts: $postsData');
      List<MiniPost> posts = postsData.map((post) => MiniPost.fromJson(post)).toList();
      return posts;
    } else {
      throw Exception('Failed to load search results');
    }
  }
  
}