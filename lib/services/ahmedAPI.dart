import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://user1710883763789.requestly.tech'; // Base URL




  Future<Map<String, dynamic>> getUserOverview() async {
    final String endpoint = '/user/lofi/overview'; // Endpoint for fetching user overview
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User overview not found: ${response.body}');
      } else {
        throw Exception('Failed to fetch user overview: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user overview: $e');
    }
  }

  Future<List<dynamic>> getUserComments() async {
    final String endpoint = '/user/lofi/comments'; // Endpoint for fetching user comments
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User comments not found: ${response.body}');
      } else {
        throw Exception('Failed to fetch user comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user comments: $e');
    }
  }

  Future<Map<String, dynamic>> getUserDownvoted() async {
    final String endpoint = '/user/lofi/downvoted'; // Endpoint for fetching user downvoted items
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User downvoted items not found: ${response.body}');
      } else {
        throw Exception('Failed to fetch user downvoted items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user downvoted items: $e');
    }
  }

  Future<Map<String, dynamic>> getUserUpvoted() async {
    final String endpoint = '/user/lofi/upvoted'; // Endpoint for fetching user upvoted items
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User upvoted items not found: ${response.body}');
      } else {
        throw Exception('Failed to fetch user upvoted items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user upvoted items: $e');
    }
  }

  Future<Map<String, dynamic>> getUserSubmittedPosts() async {
    final String endpoint = '/user/lofi/submitted'; // Endpoint for fetching user submitted posts
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User submitted posts not found: ${response.body}');
      } else {
        throw Exception('Failed to fetch user submitted posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }
}

