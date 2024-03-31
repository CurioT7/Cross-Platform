import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_info.dart';

class ApiService {
  final String _baseUrl =
      'https://user1710883763789.requestly.tech'; // Base URL

  Future<Map<String, dynamic>> getUserOverview() async {
    const String endpoint =
        '/user/lofi/overview'; // Endpoint for fetching user overview
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User overview not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user overview: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user overview: $e');
    }
  }

  Future<List<dynamic>> getUserComments() async {
    const String endpoint =
        '/user/lofi/comments'; // Endpoint for fetching user comments
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User comments not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user comments: $e');
    }
  }

  Future<Map<String, dynamic>> getUserDownvoted() async {
    const String endpoint =
        '/user/lofi/downvoted'; // Endpoint for fetching user downvoted items
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User downvoted items not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user downvoted items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user downvoted items: $e');
    }
  }

  Future<Map<String, dynamic>> getUserUpvoted() async {
    const String endpoint =
        '/user/lofi/upvoted'; // Endpoint for fetching user upvoted items
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User upvoted items not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user upvoted items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user upvoted items: $e');
    }
  }

  Future<Map<String, dynamic>> getUserSubmittedPosts() async {
    const String endpoint =
        '/user/lofi/submitted'; // Endpoint for fetching user submitted posts
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User submitted posts not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user submitted posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }

  Future<AccountInfo> getAccountInfo() async {
    const String baseUrl = 'http://10.0.2.2:3000/api/';
    const String endpoint = 'settings/v1/me/prefs';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return AccountInfo.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User submitted posts not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user submitted posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }
}
