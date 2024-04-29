import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_info.dart';

class ApiService {
 //final String _baseUrl = 'http://20.19.89.1'; // Base URL
   final String _baseUrl= 'http://192.168.1.13:3000';

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
    const String baseUrl = 'http://20.19.89.1/api/';
    const String endpoint = 'settings/v1/me/prefs';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjE5MDgzY2UyNjI5ZDdmNjY5YWNjM2EiLCJpYXQiOjE3MTI5NjA1OTcsImV4cCI6MTcxMzA0Njk5N30.BnYis_eh62deVbU--jhLzW7QPrCSkB6r9oc3KePnccY";

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

  Future followUser(String userName) async {
    const String baseUrl = 'http://20.19.89.1/api/';
    const String endpoint = 'me/friends';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      log(userName);
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"friendUsername": userName}),
      );

      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }

  Future unfollowUser(String userName) async {
    const String baseUrl = 'http://20.19.89.1/api/';
    const String endpoint = 'me/friends';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      log(userName);
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"friendUsername": userName}),
      );
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }

  Future blockUser(String userName) async {
    const String baseUrl = 'http://20.19.89.1/api/';
    const String endpoint = 'User/block';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"usernameToBlock": userName}),
      );
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }

  Future<AccountInfo> unblockUser(String userName) async {
    const String baseUrl = 'http://20.19.89.1/api/';
    const String endpoint = 'User/unblock';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"usernameToBlock": userName}),
      );
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch user submitted posts: $e');
    }
  }




}
