import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import C:\Users\yaray\OneDrive\Documents\HEM\Software\Curio_v1\Cross-Platform\lib\Models\post.dart
import 'package:curio/Models/post.dart';

import 'package:curio/Models/comment.dart';

class logicAPI {
  //final String _baseUrl = 'http://20.19.89.1';// Replace with your backend URL
  final String _baseUrl = 'http://192.168.1.13:3000';

  Future<Map<String, dynamic>> fetchUserData(String username) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/$username/about'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);


    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Map<String, dynamic> extractUserDetails(Map<String, dynamic> userData) {
    return {
      'postKarma': userData['postKarma'],
      'commentKarma': userData['commentKarma'],
      'cakeDay': userData['cakeDay'],
      'profilePicture': userData['profilePicture'],
    };
  }

  Future<Map<String, dynamic>> fetchUsername(String token) async {
    print(token);
    //to delete
    // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
//print parameter token
    print(token);
    final response = await http.get(
      Uri.parse('$_baseUrl/api/settings/v1/me'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },);


    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Map<String, dynamic> extractUsername(Map<String, dynamic> userData) {
    return {
      'username': userData['username'],

    };
  }

  Future<int> daysSinceCakeDay(Map<String, dynamic> userDetails) async {
    final String cakeDay = userDetails['cakeDay']; // Assuming the cakeDay is in the format "Mar 2, 2024"
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final DateTime cakeDayDate = formatter.parse(cakeDay);
    final DateTime currentDate = DateTime.now();

    final int daysDifference = currentDate
        .difference(cakeDayDate)
        .inDays;
    print("date hereeeeeeeeeeeeee");
    print(daysDifference);
    return daysDifference;
  }

  // Future<Map<String, dynamic>>  createCommunity( String communityName, String typeCommunity, bool isOver18, String token) async {
  //
  //
  //   final response = await http.post(Uri.parse('$_baseUrl/api/createSubreddit'),  headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   },
  //     body: jsonEncode(<String, String>{
  //       'name': communityName,
  //       'description': 'none' ,
  //       'over18': isOver18.toString() ,
  //       'privacyMode': typeCommunity.toLowerCase(),
  //     }),);
  //
  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else if (response.statusCode == 404) {
  //     throw Exception('User not found');
  //   } else if (response.statusCode == 500) {
  //     throw Exception('Internal Server Error');
  //   } else {
  //     throw Exception('Unexpected error occurred');
  //   }
  // }
  Future<Map<String, dynamic>> createCommunity(String communityName,
      bool isOver18, String typeCommunity, String token) async {
    try {
      //  token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
      print("Tokens: $token");
      final response = await http.post(
        Uri.parse('$_baseUrl/api/createSubreddit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'name': communityName,
          'description': 'none',
          'over18': isOver18,
          'privacyMode': typeCommunity.toLowerCase(),
        }),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 404) {
          throw Exception('User not found');
        } else if (response.statusCode == 500) {
          throw Exception('Internal Server Error');
        } else {
          throw Exception('Unexpected error occurred');
        }
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error creating community: $e');
    }
  }

  //Community profile page functions
  Future<Map<String, dynamic>> joinCommunity(String token,
      String communityName) async {
    // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
    print("inside join community inside logicapi");

    final response = await http.post(
      Uri.parse('$_baseUrl/api/friend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'subreddit': communityName,
      }),
    );

    if (response.statusCode == 200) {
      print("inside join community inside logicapi 200");
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Subreddit not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      print('Unexpected status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> leaveCommunity(String token,
      String communityName) async {
    // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";

    final response = await http.post(
      Uri.parse('$_baseUrl/api/unfriend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'subreddit': communityName,
      }),
    );

    if (response.statusCode == 200) {
      print("inside leave community inside logicapi");

      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Subreddit not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      print('Unexpected status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> fetchCommunityData(String communityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/r/${Uri.encodeComponent(communityName)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
// print(communityName);
// print('$_baseUrl/api/r/${Uri.encodeComponent(communityName)}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      Map<String, dynamic> subredditData = responseData['subreddit'];
      return {
        'privacyMode': subredditData['privacyMode'],
        'name': subredditData['name'],
        'description': subredditData['description'],
        'membersCount': subredditData['members'].length,
        'banner': subredditData['banner'],
        'icon': subredditData['icon'],
      };
    } else if (response.statusCode == 404) {
      throw Exception('Subreddit not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Future<List<Post>> fetchCommunityProfilePosts(String subreddit,
      String type) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/api/r/${Uri.encodeComponent(subreddit)}/$type'));

    if (response.statusCode == 200) {
      return Post.getPosts((jsonDecode(response.body)['posts']));
    } else if (response.statusCode == 404) {
      throw Exception('Subreddit not found');
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Future<List<Map<String, dynamic>>> fetchTopPosts(String subreddit, String timeinterval) async {
  //   final response = await http.get(Uri.parse('$_baseUrl/api/r/${Uri.encodeComponent(subreddit)}/top/$timeinterval'));
  //
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     List<dynamic> posts = jsonResponse['post'];
  //
  //     return posts.map((post) {
  //       return {
  //         '_id': post['_id'],
  //         'title': post['title'],
  //         'content': post['content'],
  //         'authorName': post['authorName'],
  //         'views': post['views'],
  //         'createdAt': DateTime.parse(post['createdAt']),
  //         'upvotes': post['upvotes'],
  //         'downvotes': post['downvotes'],
  //         'linkedSubreddit': post['linkedSubreddit'],
  //         'comments': List<String>.from(post['comments']),
  //         'shares': post['shares'],
  //         'isNSFW': post['isNSFW'],
  //         'isSpoiler': post['isSpoiler'],
  //         'isOC': post['isOC'],
  //         'isCrosspost': post['isCrosspost'],
  //         'awards': post['awards'],
  //         'media': post['media'],
  //         'link': post['link'],
  //         'isDraft': post['isDraft'],
  //         '__v': post['__v'],
  //       };
  //     }).toList();
  //   } else if (response.statusCode == 404) {
  //     throw Exception('Subreddit not found');
  //   } else {
  //     throw Exception('Failed to load posts');
  //   }
  // }
  // Future<List<Post>?> fetchTopPosts(String subreddit, String timeinterval) async {
  //   try{
  //     print("inside LOGICAPI TIME INTERVAL = ");
  //     print(timeinterval);
  //     final response = await http.get(Uri.parse('$_baseUrl/api/r/${Uri.encodeComponent(subreddit)}/top/${Uri.encodeComponent(timeinterval)}'));
  //
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       List<dynamic> posts = jsonResponse['posts'];
  //
  //       return posts.map((post) => Post.fromJson(post)).toList();
  //     }
  //
  //     // return {
  //     //   '_id': post['_id'],
  //     //   'title': post['title'],
  //     //   'content': post['content'],
  //     //   'authorName': post['authorName'],
  //     //   'views': post['views'],
  //     //   'createdAt': DateTime.parse(post['createdAt']),
  //     //   'upvotes': post['upvotes'],
  //     //   'downvotes': post['downvotes'],
  //     //   'linkedSubreddit': post['linkedSubreddit'],
  //     //   'comments': List<String>.from(post['comments']),
  //     //   'shares': post['shares'],
  //     //   'isNSFW': post['isNSFW'],
  //     //   'isSpoiler': post['isSpoiler'],
  //     //   'isOC': post['isOC'],
  //     //   'isCrosspost': post['isCrosspost'],
  //     //   'awards': post['awards'],
  //     //   'media': post['media'],
  //     //   'link': post['link'],
  //     //   'isDraft': post['isDraft'],
  //     //   '__v': post['__v'],
  //     // };
  //     // }).toList();
  //     else if (response.statusCode == 404) {
  //       return null;
  //     } else {
  //       throw Exception('Failed to load posts');
  //     }
  //   } catch (e, s) {
  //     print('Exception details:\n $e');
  //     print('Stack trace:\n $s');
  //     rethrow; // Use rethrow to allow the exception to propagate up the call stack.
  //   }
  // }

  Future<List<Post>?> fetchTopPosts(String subreddit,
      String timeinterval) async {
    try {
      print("inside LOGICAPI TIME INTERVAL = ");
      print(timeinterval);
      final response = await http.get(Uri.parse(
          '$_baseUrl/api/r/${Uri.encodeComponent(subreddit)}/top/${Uri
              .encodeComponent(timeinterval)}'));


      if (response.statusCode == 200) {
        return Post.getPosts((jsonDecode(response.body)['post']));
      }

      else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
      rethrow; // Use rethrow to allow the exception to propagate up the call stack.
    }
  }

  //Comments part

  Future<List<Comment>> fetchPostComments(String postId) async {
    print("Post ID iNSIDE LOGICAPI");
    print(postId);
    final response = await http.get(
      Uri.parse('$_baseUrl/api/comments/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<dynamic> commentsJson = responseBody['comments'];
        print('success: code 200 comments');
        return Comment.getComments(commentsJson);
      } else {
        throw Exception('Failed to load comments');
      }
    } else if (response.statusCode == 404) {
      print('failure: code 404 comments');
      throw Exception('Post not found');
    } else if (response.statusCode == 500) {
      print('failure: code 500 comments');

      throw Exception('Internal Server Error');
    } else {
      // print detailed error
      print('failure: comments');

      throw Exception(
          'Failed to load comments with status code: ${response.statusCode}');
    }
  }


  Future<void> postComment(String postId, String content, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/comments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'postId': postId,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        print("comment successfully created");
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('Error 404: Not Found. Failed to post comment.');
        throw Exception('Error 404: Not Found. Failed to post comment.');
      } else if (response.statusCode == 500) {
        print('Error 500: Internal Server Error. Failed to post comment.');
        throw Exception(
            'Error 500: Internal Server Error. Failed to post comment.');
      } else {
        throw Exception('Failed to post comment with status code: ${response
            .statusCode}. Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error posting comment: $e');
    }
  }

  Future<Map<String, dynamic>> updateComment(String commentId, String content, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/updatecomments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'commentId': commentId,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        print("Comment successfully updated");
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('Error 404: Not Found. Failed to update comment.');
        throw Exception('Error 404: Not Found. Failed to update comment.');
      } else if (response.statusCode == 500) {
        print('Error 500: Internal Server Error. Failed to update comment.');
        throw Exception('Error 500: Internal Server Error. Failed to update comment.');
      } else {
        throw Exception('Failed to update comment with status code: ${response.statusCode}. Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error updating comment: $e');
    }
  }
  Future<Map<String, dynamic>> deleteComment(String commentId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/deletecomments/$commentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'commentId': commentId,
        }),
      );

      if (response.statusCode == 200) {
        print("Comment successfully deleted");
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('Error 404: Not Found. Failed to delete comment.');
        throw Exception('Error 404: Not Found. Failed to delete comment.');
      } else if (response.statusCode == 500) {
        print('Error 500: Internal Server Error. Failed to delete comment.');
        throw Exception('Error 500: Internal Server Error. Failed to delete comment.');
      } else {
        throw Exception('Failed to delete comment with status code: ${response.statusCode}. Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error deleting comment: $e');
    }
  }
}
