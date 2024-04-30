import 'dart:convert';
import 'package:curio/Views/Home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curio/post/community_card.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/community_model.dart';
import 'logicAPI.dart';
import 'package:curio/Models/post.dart';
import 'package:curio/Models/comment.dart';

import 'package:curio/Views/signUp/EmailVerificationPage.dart';
class ApiService {
  // final String _baseUrl = 'http://20.19.89.1'; // Base URL
  final String _baseUrl= 'http://10.0.2.2:3000';

  Future<http.Response> signIn(String usernameOrEmail, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/app/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      }),
    );
    return response;
  }

  Future<Map<String, dynamic>> changeEmail(String newEmail, String password,
      String token) async {
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
      final response = await http.patch(
          Uri.parse(url), headers: headers, body: jsonEncode(body));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Edit the success message here
        String editedMessage = "Your email has been successfully changed to $newEmail. Please verify your new email address.";
        return {'success': true, 'message': editedMessage};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
  Future<String?> signup(String email, String password,String username ,BuildContext context) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EmailVerificationScreen(email: email, password: password, username: username),
    //   ),
    // );
   // String baseUrl = 'http://20.19.89.1';
    //final String baseUrl= 'http://192.168.1.13:3000';

    // make a post request to the server api/auth/signup
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'username': username,
      }),
    );
    if (response.statusCode == 201) {
      // store the access token in shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', jsonDecode(response.body)['accessToken']);
    }
    return response.body;
  }
  Future<List<Map<String, String>>> communityRules(String communityId) async {
    //TODO: Implement this method to fetch community rules from the API
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock response
    return [
      {'header': 'Rule 1', 'body': 'This is the body for Rule 1'},
      {'header': 'Rule 2', 'body': 'This is the body for Rule 2'},
      {'header': 'Rule 3', 'body': 'This is the body for Rule 3'},
      {'header': 'Rule 4', 'body': 'This is the body for Rule 4'},
      {'header': 'Rule 5', 'body': 'This is the body for Rule 5'},
      {'header': 'Rule 6', 'body': 'This is the body for Rule 6'},
      {'header': 'Rule 7', 'body': 'This is the body for Rule 7'},
      {'header': 'Rule 8', 'body': 'This is the body for Rule 8'},
      {'header': 'Rule 9', 'body': 'This is the body for Rule 9'},
      {'header': 'Rule 10', 'body': 'This is the body for Rule 10'},
    ];
  }
  Future<Map<String, dynamic>> isUsernameAvailable(String username) async {
    if (username.isEmpty) {
      return {'available': false, 'message': 'Username cannot be empty'};
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/api/auth/username_available/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check username availability');
    }
  }

  Future<Map<String, dynamic>> isEmailAvailable(String email) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/email_available/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 409) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check email availability');
    }
  }

  Future<Map<String, dynamic>> resetPassword(String username, String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
      }),
    );
  
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal server error');
    } else {
      throw Exception('Failed to reset password');
    }
  }
Future<Map<String, dynamic>> fetchSavedPostsAndComments(String token) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/api/saved_categories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> body = jsonDecode(response.body);
    List<Post> savedPosts = [];
    if(body['savedPosts'] != []) {
      print("Saved Posts: ${body['savedPosts']}");
      savedPosts = Post.getPosts(body['savedPosts']);
    }
    List<Comment> savedComments= [];
    List<String>titles = [];
    if(body['savedComments'] != []) {
      print("Saved Comments: ${body['savedComments']}");
      savedComments = Comment.getComments(body['savedComments']);
      // itterate over the saved comments and list all linkedposts

      for (var comment in savedComments) {
        var objectID = comment.linkedPost;
        try {
          print(objectID);
          final response = await http.get(
            Uri.parse('$_baseUrl/api/info?objectID=$objectID&objectType=post'),
            headers:<String, String> {
              'Content-Type': 'application/json; charset=UTF-8',

            },
          );

          if (response.statusCode == 200) {
            titles.add(jsonDecode(response.body)['item']['title']);
          } else {
            print('Response body: ${response.body}');
            throw Exception('Failed to load info with status code: ${response.statusCode}');
          }
        } catch (e) {
          throw Exception('Failed to load info. Error: $e');
        }
      }
    }
    return {'savedPosts': savedPosts, 'savedComments': savedComments, 'titles': titles};
  }
  else{
    throw Exception('Failed to fetch saved posts and comments');
  }
}

Future<Map<String, dynamic>> submitPost(Map<String, dynamic> post, String token, XFile? imageFile) async {
  print("submitting post");
  print(jsonEncode(post));


  var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/submit'));

  request.fields.addAll(post.map((key, value) => MapEntry(key, value.toString())));

  if (imageFile != null) {
  print("image file: ${imageFile.path}");
    request.files.add(await http.MultipartFile.fromPath(
      'media', // consider 'media' as the key for the image file in your server
      imageFile.path,
    ));
  }

  request.headers.addAll(<String, String>{
    'Authorization': 'Bearer $token',
  });

  var response = await request.send();

  if (response.statusCode == 201) {
    print("Post submitted");
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  } else {
    print("response body: ${await response.stream.bytesToString()}");
    return {'success': false, 'message': 'Failed to submit post'};
  }
}

Future<List<Community>> getCommunities(String token, BuildContext context) async {
  final logicAPI apiLogic = logicAPI();
  Map<String, dynamic> userProfile = await apiLogic.fetchUsername(token);
  final userName = apiLogic.extractUsername(userProfile);
  final name = userName['username'];
  print("User name: $name");
  final response = await http.get(
    Uri.parse('$_baseUrl/api/user/$name/communities'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  String errorMessage;
  if (response.statusCode == 200) {
    final communities = jsonDecode(response.body)['communities'];
    final body = communities as List;
    return body.map((dynamic item) => Community.fromJson(item)).toList();
  } else {

    if (response.statusCode == 404) {
      errorMessage = 'User not found';
    } else {
      errorMessage = 'No communities found you have to create/join at least one';
    }

    // Show snackbar with error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 2),
      ),
    );

    throw Exception(errorMessage);
  }
}

  Future<Map<String, dynamic>> getCommunityMembers(String communityId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/subreddit/$communityId/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch subreddit members');
    }
  }

  Future<Map<String, dynamic>> reportUser() async {
    const String endpoint = '/api/report_user'; // Endpoint for reporting user
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to report user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to report user: $e');
    }
  }

  Future<Map<String, dynamic>> getUserAboutInfo(String username) async {
    final String endpoint = '/api/user/$username/about'; // Endpoint for fetching user about info
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('User not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch user about info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user about info: $e');
    }
  }

  Future<Map<String, dynamic>> createUserSubredditRelationship(String userId,
      String subredditId) async {
    final String endpoint = '/api/friend'; // Endpoint for creating user-subreddit relationship
    final url = Uri.parse('$_baseUrl$endpoint');

    // Define the request body
    final Map<String, dynamic> requestBody = {
      'userId': userId,
      'subredditId': subredditId,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception(
            'Failed to create user-subreddit relationship: ${response.body}');
      } else {
        throw Exception(
            'Failed to create user-subreddit relationship: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create user-subreddit relationship: $e');
    }
  }

  Future<Map<String, dynamic>> removeUserSubredditRelationship(String userId,
      String subredditId) async {
    final String endpoint = '/api/unfriend'; // Endpoint for removing user-subreddit relationship
    final url = Uri.parse('$_baseUrl$endpoint');

    // Define the request body
    final Map<String, dynamic> requestBody = {
      'userId': userId,
      'subredditId': subredditId,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Handle 404 error specifically
        throw Exception('Subreddit not found: ${response.body}');
      } else {
        throw Exception(
            'Failed to remove user-subreddit relationship: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove user-subreddit relationship: $e');
    }
  }

  Future<Map<String, dynamic>> signInWithToken(String token) async {
    const String endpoint = '/api/auth/google/'; // Endpoint for signing in with token
    // const baseUrl = 'http://20.19.89.1';

     // final String baseUrl= 'http://192.168.1.7';

    final url = Uri.parse('$_baseUrl$endpoint');

    // Define the request body
    final Map<String, dynamic> requestBody = {
      'token': token,
    };

    try {
      final http.Response response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // Save the token in shared preferences
        print("Sign in with token: ${responseData['accessToken']}");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['accessToken']);
        return responseData;
      } else {
        throw Exception(
            'Failed to sign in with token: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Failed to sign in with token: $e');
    }
  }
}

class MockGoogleAuthApi {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<void> initiateGoogleAuth() async {
    print('Mock: Initiating Google Authentication...');
  }

  Future<String> handleGoogleAuthCallback() async {
    print('Mock: Handling Google Authentication Callback...');
    return 'mock_access_token';
  }
}

class GoogleAuthSignInService {

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser == null) {
        print("Google Sign In failed");
        return null;
      }
      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleAuth = await googleUser!
          .authentication;
      // Create a new credential

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // save the token into secure storage
      // Once signed in, return the UserCredential
      print("Token from google: ${googleAuth.accessToken}");
      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
          googleCredential);
      return userCredential;
    }catch (e) {
      print(e.toString());
    }
    return null;
  }
}
