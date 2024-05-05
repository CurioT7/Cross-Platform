import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/Models/post.dart';
class ApiService {
  // final String baseUrl = 'http://20.19.89.1/api';
   final String baseUrl= 'http://192.168.1.13:3000/api';
  // final String baseUrl ='http://20.199.94.136/api';

Future<Map<String, dynamic>> getPosts(String type, {int page = 1 , String? token, String timeframe = 'year'} ) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/homepage/$type/$timeframe?page=$page'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Raw response: ${response.body}'); // Print the raw response

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('Decoded response: $responseBody'); // Print the decoded response

      if (response.statusCode == 200) {
        List<dynamic> postsJson = responseBody['posts'];
        print('Posts JSON: $postsJson'); // Print the posts JSON

        List<Post> posts = postsJson.map((json) {
          try {
            print('Post JSON: ${json}'); // Print the post JSON
            return Post.fromJson(json);
          } catch (e) {
            print('Exception when creating Post: $e');
            throw e;
          }
        }).toList();

        return {
          'totalPosts': responseBody['totalPosts'],
          'posts': posts,
        };
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

    Future<Map<String, dynamic>> getBestPosts(String token, int page) async {
      return getPosts('best', token: token, page: page);
    }
    
    Future<Map<String, dynamic>> getDiscoveryPosts(String token, int page) async {
      return getPosts('new', token: token, page: page);
    }
    
    Future<Map<String, dynamic>> getPopularPosts(String token, int page) async {
      return getPosts('top', token: token, page: page);
    }
    
    Future<Map<String, dynamic>> getTrendingPosts(String token, int page) async {
      return getPosts('hot', token: token, page: page);
    }
  Future<Post> fetchPostByID(String objectID, String token) async {
    try {
      print(objectID);
      final response = await http.get(
        Uri.parse('$baseUrl/info?objectID=$objectID&objectType=post'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add this line
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body)['item'];
        print('Response body: $responseBody'); // Print the response body
        return Post.fromJson(responseBody);
      } else {
        print('Response body: ${response.body}');

        throw Exception('Failed to load info with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load info. Error: $e');
    }
  }
  // Future<List<Post>> getTrendingPosts() async {
  //   try {
  //     final response = await http.get(Uri.parse('$baseUrl/trendingSearches'));
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseBody = json.decode(response.body);
  //       if (responseBody['success']) {
  //         List<dynamic> postsJson = responseBody['posts'];
  //         return postsJson.map((json) => Post.fromJson(json)).toList();
  //       } else {
  //         throw Exception('Failed to load posts');
  //       }
  //     } else if (response.statusCode == 404) {
  //       throw Exception('No Trendings Today');
  //     } else if (response.statusCode == 500) {
  //       throw Exception('Error retrieving search results');
  //     } else {
  //       throw Exception('Failed to load posts with status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception occurred: $e');
  //     throw e;
  //   }
  // }
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

  Future<bool> hidePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hide'),
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
      throw Exception('Failed to hide post');
    }
  }
  
  Future<bool> unhidePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unhide'),
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
      throw Exception('Failed to unhide post');
    }
  }
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
  Future<Map<String, dynamic>> deletePost(String postId, String token) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/deletepost/$postId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Server responded with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to delete post');
  }

}


}