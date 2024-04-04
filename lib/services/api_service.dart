import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curio/post/community_card.dart';
import 'package:flutter/material.dart';

import 'package:curio/Views/signUp/EmailVerificationPage.dart';
class ApiService {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<http.Response> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
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
  Future<UserCredential?> signup(String email, String password,String username ,BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerificationScreen(email: email, password: password, username: username),
      ),
    );
    return null;
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

  Future<Map<String, dynamic>> ForgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/forgot_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send reset password link');
    }
  }



  Future<List<Community>> getCommunities(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/subreddit/$token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Community.getCommunities(jsonDecode(response.body));
    } else {
      // retrun some dummy data
      return Community.getCommunities([
        {
          'name': 'Flutter',
          'image': Icons.flutter_dash,
          'followers': 100,
          'isFollowing': false,
        },
        {
          'name': 'Dart',
          'image': Icons.code,
          'followers': 50,
          'isFollowing': true,
        },
        {
          'name': 'Firebase',
          'image': Icons.fireplace,
          'followers': 200,
          'isFollowing': false,
        },
      ]);
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
    final String endpoint = '/user/$username/about'; // Endpoint for fetching user about info
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
    final String endpoint = '/api/auth/google/'; // Endpoint for signing in with token
    final baseUrl = 'http://10.0.2.2:3000';
    final url = Uri.parse('$baseUrl$endpoint');

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
