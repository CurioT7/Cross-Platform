import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class logicAPI {
  final String _baseUrl = 'http://10.0.2.2:3000';// Replace with your backend URL

  Future<Map<String, dynamic>> fetchUserData( String username ) async {
    final response = await http.get( Uri.parse('$_baseUrl/user/$username/about'),   headers: <String, String>{
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

  Future<Map<String, dynamic>> fetchUsername( String token ) async {
    print (token);
    //to delete
    // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
//print parameter token
    print(token);
    final response = await http.get( Uri.parse('$_baseUrl/api/settings/v1/me'),   headers: <String, String>{
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

    final int daysDifference = currentDate.difference(cakeDayDate).inDays;
    print("date hereeeeeeeeeeeeee");
    print( daysDifference);
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
  Future<Map<String, dynamic>> createCommunity(String communityName, bool isOver18, String typeCommunity, String token) async {
    try {
      //  token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";

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
  Future<Map<String, dynamic>> joinCommunity(String token, String communityName) async {
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

  Future<Map<String, dynamic>> leaveCommunity(String token, String communityName) async {
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

  Future<List<Map<String, dynamic>>> fetchCommunityProfilePosts(String subreddit, String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/r/${Uri.encodeComponent(subreddit)}/$type' ));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> posts = jsonResponse['posts'];
print("sort by ");
print(type);
print("correct");
      return posts.map((post) {
        return {
          '_id': post['_id'],
          'title': post['title'],
          'content': post['content'],
          'authorName': post['authorName'],
          'views': post['views'],
          'createdAt': post['createdAt'],
          'upvotes': post['upvotes'],
          'downvotes': post['downvotes'],
          'linkedSubreddit': post['linkedSubreddit'],
          'comments': post['comments'],
          'shares': post['shares'],
          'isNSFW': post['isNSFW'],
          'isSpoiler': post['isSpoiler'],
          'isOC': post['isOC'],
          'isCrosspost': post['isCrosspost'],
          'awards': post['awards'],
          'media': post['media'],
          'link': post['link'],
          'isDraft': post['isDraft'],
          '__v': post['__v'],
        };
      }).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Subreddit not found');
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
