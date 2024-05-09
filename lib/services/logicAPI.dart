import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import C:\Users\yaray\OneDrive\Documents\HEM\Software\Curio_v1\Cross-Platform\lib\Models\post.dart
import 'package:curio/Models/post.dart';

import 'package:curio/Models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/minipost.dart';
import '../Notifications/notificationModel.dart';
import '../widgets/miniPostCard.dart';
import '../widgets/searchCommentCard.dart';
import 'package:flutter/material.dart';

class logicAPI {
  // final String _baseUrl = 'http://20.19.89.1';// Replace with your backend URL
  //  final String _baseUrl = 'http://192.168.1.8:3000';
  final String _baseUrl = 'http://10.0.2.2:3000';

//final String _baseUrl= 'http://20.199.94.136';

  Future<Map<String, dynamic>> fetchUserData(String username) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/user/$username/about'),
      headers: <String, String>{
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

  Future<Map<String, dynamic>> extractUserDetails(
      Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'karma', userData['postKarma'] + userData['commentKarma']);
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cakeday', daysDifference);

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
      bool isOver18, String typeCommunity, String token,
      String description) async {
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
          'description': description,
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
        "isOver18": subredditData['isOver18'],
        'moderators': subredditData['moderators'].map((
            moderator) => moderator['username']).toList(),
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

  void fetchJoinedCommunityNames(String username, String token,
      String name) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/user/$username/communities'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          List<dynamic> communitiesJson = responseBody['communities'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          for (var community in communitiesJson) {
            String communityName = community['name'];
            bool isJoined = name == communityName;

            if (isJoined) {
              await prefs.setBool('isJoinedSubreddit', true);
              return;
            }
          }
          await prefs.setBool('isJoinedSubreddit', false);
        } else {
          throw Exception('Failed to load communities');
        }
      } else {
        throw Exception('Failed to load communities with status code: ${response
            .statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
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

  Future<Map<String, dynamic>> updateComment(String commentId, String content,
      String token) async {
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
        throw Exception(
            'Error 500: Internal Server Error. Failed to update comment.');
      } else {
        throw Exception('Failed to update comment with status code: ${response
            .statusCode}. Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error updating comment: $e');
    }
  }

  Future<Map<String, dynamic>> deleteComment(String commentId,
      String token) async {
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
        throw Exception(
            'Error 500: Internal Server Error. Failed to delete comment.');
      } else {
        throw Exception('Failed to delete comment with status code: ${response
            .statusCode}. Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error deleting comment: $e');
    }
  }

  //voteComment

  Future<void> voteComment(String commentId, int direction,
      String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/vote'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'itemID': commentId,
        'itemName': 'comment',
        'direction': direction,
      }),
    );
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['success']) {
        print(responseBody['message']);
      } else {
        throw Exception('Unexpected error: ${responseBody['message']}');
      }
    } else if (response.statusCode == 404) {
      throw Exception(responseBody['message']);
    } else if (response.statusCode == 400) {
      throw Exception(responseBody['message']);
    } else if (response.statusCode == 500) {
      throw Exception(responseBody['message']);
    } else if (response.statusCode == 401) {
      throw Exception(responseBody['message']);
    } else {
      throw Exception(
          'Failed to vote on comment. Status code: ${response.statusCode}');
    }
  }

  //save comment
  void saveComment(String commentId, String token) async {
    print("inside save comment");
    final response = await http.post(
      Uri.parse('$_baseUrl/api/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'category': 'comment',
        'id': commentId,
      }),
    );

    if (response.statusCode == 200) {
      print("Comment saved successfully");
    } else if (response.statusCode == 400) {
      throw Exception(
          'Bad Request: The server could not understand the request due to invalid syntax.');
    } else if (response.statusCode == 401) {
      throw Exception(
          'Unauthorized: The client must authenticate itself to get the requested response.');
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden: The client does not have access rights to the content.');
    } else if (response.statusCode == 404) {
      throw Exception(
          'Not Found: The server can not find the requested resource.');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Internal Server Error: The server has encountered a situation it doesnt know how to handle');
    } else {
      throw Exception(
          'Failed to save comment. Status code: ${response.statusCode}');
    }
  }

  //unsave comment

  void unsaveComment(String commentId, String token) async {
    print("inside unsave comment");

    final response = await http.post(
      Uri.parse('$_baseUrl/api/unsave'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': commentId,
      }),
    );

    if (response.statusCode == 200) {
      print("Comment unsaved successfully");
    } else if (response.statusCode == 400) {
      throw Exception(
          'Bad Request: The server could not understand the request due to invalid syntax.');
    } else if (response.statusCode == 401) {
      throw Exception(
          'Unauthorized: The client must authenticate itself to get the requested response.');
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden: The client does not have access rights to the content.');
    } else if (response.statusCode == 404) {
      throw Exception(
          'Not Found: The server can not find the requested resource.');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Internal Server Error: The server has encountered a situation it doesnt know how to handle');
    } else {
      throw Exception(
          'Failed to unsave comment. Status code: ${response.statusCode}');
    }
  }

  //getpostbyid

  Future<Post> fetchPostByID(String objectID, String token) async {
    try {
      print(objectID);
      final response = await http.get(
        Uri.parse('$_baseUrl/api/info?objectID=$objectID&objectType=post'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Post post = Post.fromJson((jsonDecode(response.body)['item']));
        print('Post: $post');
        print("post fetched successfully by id");
        return post;
      } else {
        print('Response body: ${response.body}');

        throw Exception('Failed to load info with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load info. Error: $e');
    }
  }

  //getCommentbyid
  Future<Comment> fetchCommentByID(String objectID) async {
    try {
      print(objectID);
      final response = await http.get(
        Uri.parse('$_baseUrl/api/info?objectID=$objectID&objectType=comment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',

        },
      );

      if (response.statusCode == 200) {
        return Comment.fromJson((jsonDecode(response.body)['item']));
      } else {
        print('Response body: ${response.body}');

        throw Exception(
            'Failed to load info with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load info. Error: $e');
    }
  }

//Notifications

  Future<List<NotificationModel>> getAllNotifications(String token) async {
    final url = Uri.parse('$_baseUrl/api/notifications/history');


    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('success 200 notifications');
      print(response.body);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['success']) {
        List<dynamic> notificationsJson = responseBody['notifications'];
        print('success: code 200 notifications');
        return NotificationModel.getNotifications(notificationsJson);
      } else {
        throw Exception('Failed to load notifications');
      }
    } else {
      throw Exception(
          'Failed to load notifications with status code: ${response
              .statusCode}');
    }
  }

  Future<List<String>> getReadNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/notifications/read'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List? notificationsJson = data['readNotifications'];
      if (notificationsJson != null) {
        List<NotificationModel> notifications = NotificationModel
            .getNotifications(notificationsJson);
        return notifications.map((notification) => notification.id).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load notifications');
    }
  }


  Future<bool> markNotificationAsRead(String token,
      String notificationID) async {
    print("inside notifcation marked read");

    final response = await http.post(
      Uri.parse('$_baseUrl/api/notifications/read-notification'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'notificationID': notificationID,
      }),
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['success']) {
        print("notifcation marked read succesfully");
        return true;
      } else {
        throw Exception(data['message']);
      }
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      throw Exception('Notification is already read');
    } else if (response.statusCode == 401) {
      print(response.statusCode);

      throw Exception('Unauthorized');
    } else if (response.statusCode == 404) {
      print(response.statusCode);

      throw Exception('Notification not found');
    } else if (response.statusCode == 500) {
      print(response.statusCode);

      throw Exception('Internal Server error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> hideNotification(String token,
      String notificationID) async {
    final String endpoint = '/api/notifications/hide';
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'notificationID': notificationID,
        }),
      );

      if (response.statusCode == 200) {
        print("hide notifcation successful");
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        print(response.statusCode);

        throw Exception('Unauthorized');
      } else if (response.statusCode == 500) {
        print(response.statusCode);

        throw Exception('Internal Server error');
      } else {
        throw Exception('Failed to hide notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to hide notification: $e');
    }
  }

  Future<Map<String, dynamic>> unhideNotification(String token,
      String notificationID) async {
    final String endpoint = '/api/notifications/unhide';
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'notificationID': notificationID,
        }),
      );

      if (response.statusCode == 200) {
        print("unhide notifcation successful");

        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        print(response.statusCode);

        throw Exception('Unauthorized');
      } else if (response.statusCode == 404) {
        print(response.statusCode);

        throw Exception('Notification not found');
      } else if (response.statusCode == 500) {
        print(response.statusCode);

        throw Exception('Internal Server error');
      } else {
        throw Exception(
            'Failed to unhide notification: ${response.statusCode}');
      }
    } catch (e) {
      print(e);

      throw Exception('Failed to unhide notification: $e');
    }
  }

  //get saved comments

  Future<List<String>> fetchSavedCommentIds(String token) async {
    print("inside fetchSavedCommentIds");
    final response = await http.get(
      Uri.parse('$_baseUrl/api/saved_categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body.isEmpty || body['savedComments'] == null) {
        return [];
      }
      print("saved comments ids success 200");
      List<Comment> comments = Comment.getComments(body['savedComments']);
      List<String> commentIds = comments.map((comment) => comment.id.toString())
          .toList();
      return commentIds;
    } else {
      throw Exception('Failed to fetch saved comment IDs');
    }
  }

  //fetch search hashtag

  Future <List<dynamic>> fetchHashtagResultsComments(String searchQuery) async {
    //final String query = searchOpts['query'];
    //const String type = 'comment';
    //final String sortOption = searchOpts['sortOption'];
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');


    final String url =
        '/api/searchHashtags/%23$searchQuery';
    print('Fetching comments from: $url');
    final response = await http.get(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // result is a list of comments with the follwoing additional fields:
    // linkedPostTitle, linkedPostAuthor, linkedPostNumComments, linkedPostNumUpvotes
    final List<dynamic> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> comments = jsonDecode(response.body)['comments'];
      for (var comment in comments) {
        final String linkedPostId = comment['linkedPost'];
        final postResponse = await http.get(
          Uri.parse(
              '$_baseUrl/api/info?objectID=$linkedPostId&objectType=post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (postResponse.statusCode == 200) {
          Map<String, dynamic> post = jsonDecode(postResponse.body);
          post = post['item'];
          comment['linkedPostTitle'] = post['title'];
          comment['linkedPostNumComments'] = post['comments']!.length;
          comment['linkedPostNumUpvotes'] = post['upvotes'];
          comment['postCreatedAt'] = post['createdAt'];
          comment['linkedPostId'] = post['_id'];
          final linkedSubreddit = comment['linkedSubreddit'];
          if (linkedSubreddit == null) {
            comment['linkedSubreddit'] = 'Unknown';
          } else {
            final subredditResponse = await http.get(
              Uri.parse(
                  '$_baseUrl/api/info?objectID=$linkedSubreddit&objectType=subreddit'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );
            if (subredditResponse.statusCode == 200) {
              Map<String, dynamic> subreddit =
              jsonDecode(subredditResponse.body);
              subreddit = subreddit['item'];
              comment['linkedSubreddit'] = subreddit['name'];
            } else {
              comment['linkedSubreddit'] = 'Unknown';
            }
            result.add(comment);
          }
        }


        else {
          throw Exception('Failed to fetch the post');
        }
      }
      print('Comments: $result');
      return result;
    }
    else if (response.statusCode == 404)

    {
      return result;
    }
    else {
      throw Exception(
          'Failed to load comments with status code: ${response.statusCode}');
    }
  }

  Future <List<MiniPost>> fetchHashtagResultsPosts(String searchQuery) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');


    final String url =
        '/api/searchHashtags/%23$searchQuery';
    print('Fetching Posts from: $url');
    final response = await http.get(
      Uri.parse('$_baseUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    // result is a list of comments with the follwoing additional fields:
    // linkedPostTitle, linkedPostAuthor, linkedPostNumComments, linkedPostNumUpvotes

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> postsData = jsonDecode(
          response.body)['posts'] != null ? List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['posts']) : [];
print("success fetch post by id");
      print('Posts: $postsData');
      // List<MiniPost> posts = MiniPost.getMiniPosts(jsonDecode(response.body)['posts'])
      //     .toList();

      List<MiniPost> posts = postsData.map((post) => MiniPost.fromJson(post)).toList();

      return posts;
    }
    else if (response.statusCode == 404)

    {
      print('no posts found in search by hashtag');
      List<MiniPost> posts = [];
      return posts;
    }else {
      throw Exception(
          'Failed to load posts with status code: ${response.statusCode}');
    }
  }
  Future<void> getCommunitySettings(String subreddit, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/communitySettings/$subreddit'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Response data: ${response.body}');
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load community settings');
    }
  }
  Future<bool> updateCommunitySettingsDescription(String token, String subreddit, String description) async {
    getCommunitySettings(subreddit, token);
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/updateCommunitySettings/$subreddit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        "name": subreddit,

        "description": description,

      }),
    );

    if (response.statusCode==200) {

      return true;}
    else if (response.statusCode==404) {
      throw Exception('Subreddit not found');
    } else if (response.statusCode==500) {
      throw Exception('Error retrieving community settings updates');
    }
    else {
      throw Exception('Failed to update community settings');
    }
  }

  Future<bool> updateCommunitySettingsPrivacy(String token, String subreddit, String privacyMode, String isover18) async {
    getCommunitySettings(subreddit, token);

    print("subeddit ");
    print(subreddit);
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/updateCommunitySettings/$subreddit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{

      "name": subreddit,
        "isNSFW": isover18,
        "privacyMode": privacyMode,
      }),
    );

    if (response.statusCode==200) {

        return true;}
    else if (response.statusCode==404) {
      throw Exception('Subreddit not found');
    } else if (response.statusCode==500) {
      throw Exception('Error retrieving community settings updates');
    }
    else {
        throw Exception('Failed to update community settings');
    }
  }

}
