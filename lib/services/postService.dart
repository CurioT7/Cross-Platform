import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/Models/post.dart';
class ApiService {
  final String baseUrl = 'http://192.168.1.13:3000/api';
  // final String baseUrl= 'http://192.168.1.7/api';

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

  Future<List<Post>> getPopularPosts() async {
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
Future<void> castVote(String itemID, int direction, String token) async {
  final String url = '$baseUrl/vote';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  final Map<String, dynamic> body = {
    'itemID': itemID,
    'itemName': 'post',
    'direction': direction,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to cast vote: ${response.body}');
  }
}
Future<bool> spoilPost(String postId, String token) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/spoil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'postId': postId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to spoil post');
    }
  } catch (e) {
    print('An error occurred: $e');
    throw e;
  }
}
  Future<bool> unspoilPost(String postId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/unspoil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'postId': postId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to unspoil post');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw e;    
    }
  }

Future<bool> lockPost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lock'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'itemID': postId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to lock post');
    }

  }

  Future<bool> unlockPost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unlock'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'itemID': postId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to unlock post');
    }
  }

  Future<bool> savePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'category': 'post',
        'id': postId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to save post');
    }
  }

  Future<bool> unsavePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unsave'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': postId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to unsave post');
    }
  }

//   Future<bool> hidePost(String postId, String token) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/hide'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'postId': postId}),
//     );

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       throw Exception('Failed to hide post');
//     }
//   }
  
//   Future<bool> unhidePost(String postId, String token) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/unhide'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'postId': postId}),
//     );

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       throw Exception('Failed to unhide post');
//     }
//   }
Future<bool> markAsNsfw(String postId, String token) async {
  final response = await http.post(
    Uri.parse('$baseUrl/marknsfw'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'postId': postId,
    }),
  );

  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
    return true;
  } else {
    print('Server responded with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to mark post as NSFW');
  }
}
  Future<bool> unmarkAsNsfw(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unmarknsfw'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'postId': postId,
      }),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return true;
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to unmark post as NSFW');
    }
  }
}