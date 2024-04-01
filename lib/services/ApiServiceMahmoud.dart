import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceMahmoud {
  final String _baseUrlMoch = 'https://user1709759645693.requestly.tech'; // Base URL for moch
  final String _baseUrlDataBase = 'http://10.0.2.2:3000'; // Base URL for moch

  Future<Map<String, dynamic>> changeEmail(String newEmail, String password, String token) async {
    final String url = '$_baseUrlMoch/api/auth/change_email';
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
    final url = Uri.parse('$_baseUrlMoch$endpoint');

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
    final url = Uri.parse('$_baseUrlMoch$endpoint');

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
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

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

  Future<Map<String, dynamic>> getHotPosts() async {
    print('fetching hot posts  from api service mahmoud ');
    final String endpoint = '/api/hot';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch hot posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch hot posts: $e');
    }
  }

  Future<Map<String, dynamic>> getNewPosts() async {
    final String endpoint = '/api/new';
    final url = Uri.parse('$_baseUrlMoch$endpoint');
    print('fetching new posts  from api service mahmoud ');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch new posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch new posts: $e');
    }
  }

  Future<Map<String, dynamic>> getRisingPosts() async {
    print('fetching rising posts  from api service mahmoud  ');
    final String endpoint = '/api/rising';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch rising posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch rising posts: $e');
    }
  }

  Future<Map<String, dynamic>> getRandomPosts() async {
    print('fetching random posts  from api service mahmoud');
    final String endpoint = '/api/random';
    print('$_baseUrlMoch$endpoint');
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch hot posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch hot posts: $e');
    }
  }

  Future<Map<String, dynamic>> getTopNowPosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/7.2';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }


  Future<Map<String, dynamic>> getTopTodayPosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/24.0';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }


  Future<Map<String, dynamic>> getTopThisWeekPosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/168.0';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }


  Future<Map<String, dynamic>> getTopThisMonthPosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/720.0';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }


  Future<Map<String, dynamic>> getTopThisYearPosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/2555.0';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }
  Future<Map<String, dynamic>> getTopAllTimePosts() async {
    print('fetching top posts  from api service mahmoud');
    final String endpoint = '/api/top/12000.0';
    final url = Uri.parse('$_baseUrlMoch$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Page not found'};
      } else {
        throw Exception('Failed to fetch top posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top posts: $e');
    }
  }

}
