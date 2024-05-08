import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiServiceMahmoud {
  final String _baseUrlMoch = 'https://user1709759645693.requestly.tech'; // Base URL for moch
  final String _baseUrl =  'http://192.168.1.13:3000'; // Base URL for moch
  final String _baseUrlDataBase =  'http://10.0.2.2:3000';
  //final String _baseUrlDataBase= 'http://192.168.1.8:3000';
  //final String _baseUrlDataBase= 'http://20.199.94.136';


  Future<Map<String, dynamic>> markViewed(String token) async {
    final String url = '$_baseUrlDataBase/api/notifications/mark-all-viewed';
    print('api called from the api page');
    print('the token is $token');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("notification  mark-viewed successfully: ${responseData['message']}");
        print('the response data is $responseData inside tge api page ');
        return responseData;
      } else {
        final errorResponse = jsonDecode(response.body);
        print('the response data is $errorResponse inside tge api page ');
        print("Error mark-viewed notification location: ${errorResponse['message']}");
        return errorResponse;
      }
    } catch (e) {
      print("Failed to mark-viewed notification: $e");
      throw Exception("Failed to mark-viewed notification : $e");
    }
  }



  Future<Map<String, dynamic>> getUnreadNotifications(String token) async {
    final String endpoint = '/api/notifications/unread';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the request header
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error');
      } else {
        throw Exception('Failed to fetch unread notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch unread notifications: $e');
    }
  }






  Future<Map<String, dynamic>> searchCommunities(String query) async {
    final String endpoint = '/api/searchCommunities/$query';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('No communities found for the given query');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: ${response.statusCode}');
      } else {
        throw Exception('Failed to search communities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search communities: $e');
    }
  }


  Future<Map<String, dynamic>> sharePostToProfile(String token, String title, String postId) async {
    final String url = '$_baseUrlDataBase/api/share';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print('the headers are $headers ');
    print('the url is $url');

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      'title': title,
      'postId': postId,
    };
    print('the request body is ');
    print(requestBody);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Check the response status code
      if (response.statusCode == 201) {
        // Return success response
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Unauthorized error
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Not Found error
        return {'success': false, 'message': 'User not found | Post not found | Subreddit not found'};
      } else if (response.statusCode == 500) {
        // Internal Server Error
        return {'success': false, 'message': 'Internal server error'};
      } else if (response.statusCode == 400) {
        // Bad Request error
        return {'success': false, 'message': 'Invalid destination'};
      } else {
        // Handle other status codes
        return {'success': false, 'message': 'Unexpected error occurred'};
      }
    } catch (e) {
      // Handle network errors
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> sharePostToSubreddit(String token, String title, String postId,String Subreddit,bool isNSFW,bool isSpoiler) async {
    final String url = '$_baseUrlDataBase/api/share';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print('the headers are $headers ');
    print('the url is $url');

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      'title': title,
      'postId': postId,
      'Subreddit': Subreddit,
      "isNSFW":isNSFW,
      "isSpoiler":isSpoiler
    };
    print('the request body is ');
        print(requestBody);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );
        print(response.statusCode)  ;
      // Check the response status code
      if (response.statusCode == 201) {
        // Return success response
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Unauthorized error
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Not Found error
        return {'success': false, 'message': 'User not found | Post not found | Subreddit not found'};
      } else if (response.statusCode == 500) {
        // Internal Server Error
        return {'success': false, 'message': 'Internal server error'};
      } else if (response.statusCode == 400) {
        // Bad Request error
        return {'success': false, 'message': 'Invalid destination'};
      } else {
        // Handle other status codes
        return {'success': false, 'message': 'Unexpected error occurred'};
      }
    } catch (e) {
      // Handle network errors
      return {'success': false, 'message': 'Error: $e'};
    }
  }



  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final String endpoint = '/api/settings/v1/me'; // Endpoint for fetching user profile
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request header
        },
      );

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


  Future<Map<String, dynamic>> getUserCommunities(String token, String username) async {
    print('i am sending the api');
    print(username);
    final String endpoint = '/api/user/$username/communities'; // Endpoint for fetching user profile
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(
        url,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: ${response.body}');
      } else {
        throw Exception('Failed to fetch user communities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user communities: $e');
    }

  }


  Future<Map<String, dynamic>> getInfo(String token, String objectID, String objectType) async {
    final String endpoint = '/api/info?objectID=$objectID&objectType=$objectType'; // Endpoint for fetching post information

    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(
        url, // Just pass the Uri object directly here
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('the response is ${response.body}');
      print('the status code is ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Subreddit not found');
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to get info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get info: $e');
    }
  }

  Future<Map<String, dynamic>> disconnectWithGoogle(String password, String token) async {
    final String url = '$_baseUrlDataBase/api/google/disconnect';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };


    final Map<String, dynamic> body = {
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('the status code is ${response.statusCode}');
      print('the response is ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Google account disconnected successfully: ${responseData['message']}");
        return responseData;
      } else if (response.statusCode == 400) {
        final errorResponse = jsonDecode(response.body);
        print("Invalid password: ${errorResponse['message']}");
        return errorResponse;
      } else if (response.statusCode == 404) {
        final errorResponse = jsonDecode(response.body);
        print("User not found: ${errorResponse['message']}");
        return errorResponse;
      } else if (response.statusCode == 401) {
        final errorResponse = jsonDecode(response.body);
        print("Unauthorized: ${errorResponse['message']}");
        return errorResponse;
      } else if (response.statusCode == 500) {
        final errorResponse = jsonDecode(response.body);
        print("Error disconnecting account: ${errorResponse['message']}");
        return errorResponse;
      } else {
        throw Exception('Failed to disconnect Google account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to disconnect Google account: $e");
    }
  }




  Future<Map<String, dynamic>> unblockUser(String token, String usernameToUnblock) async {
    final String endpoint = '/api/User/unblock'; // Endpoint for blocking a user
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    print('token is $token');
    print('the username to block is $usernameToUnblock');

    // Create the request body
    Map<String, dynamic> body = {
      "usernameToUnblock": usernameToUnblock,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(body);
    print('the request body is $requestBodyJson');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      print('the status code is ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Block updated successfully: ${responseData['message']}");
        return responseData;
      } else {
        // Log the response for further analysis
        print('Error response: ${response.body}');
        throw Exception("Failed to update block: ${response.statusCode}");
      }
    } catch (e) {
      // Log any caught exceptions for debugging
      print("Failed to update block: $e");
      throw Exception("Failed to update block: $e");
    }
  }


  Future<Map<String, dynamic>> blockUser(String token, String usernameToBlock) async {
    final String endpoint = '/api/User/block'; // Endpoint for blocking a user
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    print('token is $token');
    print('the username to block is $usernameToBlock');

    // Create the request body
    Map<String, dynamic> body = {
      "usernameToBlock": usernameToBlock,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(body);
    print('the request body is $requestBodyJson');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      print('the status code is ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Block updated successfully: ${responseData['message']}");
        return responseData;
      } else {
        // Log the response for further analysis
        print('Error response: ${response.body}');
        throw Exception("Failed to update block: ${response.statusCode}");
      }
    } catch (e) {
      // Log any caught exceptions for debugging
      print("Failed to update block: $e");
      throw Exception("Failed to update block: $e");
    }
  }





  Future<Map<String, dynamic>> updateLocation(String token, String location) async {
    final String url = '$_baseUrlDataBase/api/settings/v1/me/prefs';
    print('api called from the api page');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Construct the request body
    Map<String, String> body = {
      "locationCustomization": location,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(body);
    print('the request body is $requestBodyJson');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Location updated successfully: ${responseData['message']}");
        print('the response data is $responseData inside tge api page ');
        return responseData;
      } else {
        final errorResponse = jsonDecode(response.body);
        print('the response data is $errorResponse inside tge api page ');
        print("Error updating location: ${errorResponse['message']}");
        return errorResponse;
      }
    } catch (e) {
      print("Failed to update location: $e");
      throw Exception("Failed to update location: $e");
    }
  }


  Future<Map<String, dynamic>> updateGender(String token, String gender) async {
    final String url = '$_baseUrlDataBase/api/settings/v1/me/prefs';
    print('api called from the api page');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Construct the request body
    Map<String, dynamic> body = {
      "gender": gender, // Corrected field name to "gender"
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(body);
    print('the request body is $requestBodyJson');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Gender updated successfully: ${responseData['message']}");
        print('the response data is $responseData inside the api page');
        return responseData;
      } else {
        final errorResponse = jsonDecode(response.body);
        print('the response data is $errorResponse inside the api page ');
        print("Error updating gender: ${errorResponse['message']}");
        return errorResponse;
      }
    } catch (e) {
      print("Failed to update gender: $e");
      throw Exception("Failed to update gender: $e");
    }
  }




  Future<Map<String, dynamic>> connectWithGoogle(String password,String token, String googleToken) async {
    final String url = '$_baseUrlDataBase/api/google/connect';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'password': password,
      'token': googleToken,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Connection successful: ${responseData['message']}");
        return responseData;
      } else {
        final errorResponse = jsonDecode(response.body);
        print("Error: ${errorResponse['message']}");
        return errorResponse;
      }
    } catch (e) {
      throw Exception("Failed to connect Google account: $e");
    }
  }




  Future<Map<String, dynamic>> changeEmail(String newEmail, String password, String token) async {
    final String url = '$_baseUrlDataBase/api/auth/change_email';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': newEmail,
      'password': password,
    };

    try {
      final response = await http.patch(  // Changed from post to patch
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check the response header before decoding
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final responseData = jsonDecode(response.body);
          print('the response i recived is $responseData' );
          print('the status code is ${response.statusCode}  ');
        // Existing logic for handling different status codes
        if (response.statusCode == 200) {
          print('the message from the backend is ${responseData['message']}');
          return {'success': true, 'message': responseData['message']};
        }else if (response.statusCode == 500)
        {
          return {'success': true, 'message': 'Email change successful, please verify your new email address'};
        }
        else {
          // If response status code is not 200, we are assuming the body is still JSON
          print('the message from the backend is ${responseData['message']}');
          return {'success': false, 'message': responseData['message']};

        }
      } else {
        // If the response is not JSON, log it and return an error message
        print('Response is not JSON. Here is the body: ${response.body}');
        return {'success': false, 'message': 'Received non-JSON response'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getTopCommunities() async {
    final String url = '$_baseUrlDataBase/api/best/communities';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else {
        throw Exception('Failed to fetch top communities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top communities: $e');
    }
  }


  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword, String token) async {
    final String url = '$_baseUrlDataBase/api/auth/change_password';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print('old password sent to api $oldPassword');
    print('new password sent to api $newPassword');
    final Map<String, dynamic> body = {
      'oldPassword': oldPassword,
      'password': newPassword,
    };

    try {
      final response = await http.patch(Uri.parse(url), headers: headers, body: jsonEncode(body));
      final responseData = jsonDecode(response.body);
      print('the response i recived is ')  ;
      print(responseData['message']);
      if (response.statusCode == 200) {
        print('the message from the backend is ${responseData['message']}');
        return {'success': true, 'message': responseData['message']};


      } else if (response.statusCode == 400) {
        print('the message from the backend is ${responseData['message']}');
        return {'success': false, 'message': responseData['message']};
      } else if (response.statusCode == 401) {
        print('the message from the backend is ${responseData['message']}');
        return {'success': false, 'message': responseData['message']};
      } else if (response.statusCode == 404) {
        print('the message from the backend is ${responseData['message']}');
        return {'success': false, 'message': responseData['message']};
      } else if (response.statusCode == 500) {
        print('the message from the backend is ${responseData['message']}');
        return {'success': false, 'message': responseData['message']};
      } else {
        print('the message from the backend is ${responseData['message']}');
        return {'success': false, 'message': 'Unexpected error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }



  Future<Map<String, dynamic>> getUserPreferences(String token) async {
    final String url = '$_baseUrlDataBase/api/settings/v1/me/prefs';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

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
    final String endpoint = '/api/allpage/hot?';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(url);
        print('the response is ${response.body}');
        print('the status code is ${response.statusCode}');
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
    final String endpoint = '/api/allpage/new?';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');
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
    final String endpoint = '/api/allpage/best?';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

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
    print('fetching random posts  from api service mahmoud  ');
    final String endpoint = '/api/allpage/random?page=1';
    final url = Uri.parse('$_baseUrlDataBase$endpoint');

    try {
      final response = await http.get(url);
      print(response.statusCode);
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
