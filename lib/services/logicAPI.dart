import 'dart:convert';
import 'package:http/http.dart' as http;

class logicAPI {
  Future<int> fetchUserKarma(String username) async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/user/$username/upvoted'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      final int karma = userData['upvoted']['karma'] as int;
      return karma;
    } else if ((response.statusCode == 404)) {
      throw Exception('User not found');
    }
    else   {
      throw Exception(
          'An unexpected error occurred on the server. Please try again later.');
    }
  }



  Future<String> fetchUsername() async {
    var url = Uri.parse('http://localhost:3000/api/settings/v1/me');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final String username = userData['username'] as String;
        return username;
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception(
            'An unexpected error occurred on the server. Please try again later.');
      }
    } catch (e) {
      throw Exception('Failed to fetch username: $e');
    }
  }
}