import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceMahmoud {
  final String _baseUrl = 'https://user1709759645693.requestly.tech'; // Base URL

  Future<Map<String, dynamic>> changeEmail(String newEmail, String password, String token) async {
    final String url = '$_baseUrl/api/auth/change_email';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': newEmail,
      'password': password,
    };

    try {
      final response = await http.patch(Uri.parse(url), headers: headers, body: jsonEncode(body));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final String endpoint = '/api/settings/v1/me'; // Endpoint for fetching user profile
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: ${response.statusCode}');
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }


  Future<Map<String, dynamic>> getUserPreferences(String username) async {
    final String endpoint = '/api/settings/v1/me/prefs'; // Endpoint for fetching user preferences
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url, headers: {'username': username});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('User preferences not found');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: ${response.statusCode}');
      } else {
        throw Exception('Failed to fetch user preferences: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user preferences: $e');
    }
  }

  Future<Map<String, dynamic>> getSubredditInfo(String subredditName) async {
    final String endpoint = '/api/r/$subredditName'; // Endpoint for fetching subreddit information
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Subreddit not found');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: ${response.statusCode}');
      } else {
        throw Exception('Failed to fetch subreddit information: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch subreddit information: $e');
    }
  }
}
