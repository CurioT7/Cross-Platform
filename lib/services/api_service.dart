import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3000/api/auth';

  Future<http.Response> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    return response;
  Future<Map<String, dynamic>> changeEmail(String newEmail, String password, String token) async {
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
      final response = await http.patch(Uri.parse(url), headers: headers, body: jsonEncode(body));
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
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to signup');
    }
  }

  Future<Map<String, dynamic>> isUsernameAvailable(String username) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/username_available'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 409) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check username availability');
    }
  }
  Future<Map<String,dynamic>> isEmailAvailable(String email) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/email_available'),
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
      Uri.parse('$_baseUrl/forgot_password'),
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
}




class GoogleAuthApi {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<String> initiateGoogleAuth() async {
    final response = await http.get(Uri.parse('$baseUrl/google'));

    if (response.statusCode == 302) {
      // Extract the URL that the user should be redirected to from the response
      return response.headers['location']!;
    } else {
      throw Exception('Failed to initiate Google authentication.');
    }
  }

  Future<String> handleGoogleAuthCallback(String code) async {
    final response = await http.get(Uri.parse('$baseUrl/google/callback?code=$code'));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print('Google authentication successful.');
        return responseBody['accessToken'];
      } else {
        throw Exception('Failed to authenticate with Google: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to handle Google authentication callback.');
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
  final GoogleAuthApi _googleAuthApi = GoogleAuthApi();

  Future<String> handleSignIn() async {
    try {
      print('Initiating Google Authentication...');
      final String url = await _googleAuthApi.initiateGoogleAuth();
      return url;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> handleGoogleAuthCallback(String code) async {
    try {
      print('Handling callback...');
      final String accessToken =
      await _googleAuthApi.handleGoogleAuthCallback(code);
      print('Extracted Access Token: $accessToken');
      print('Storing Access Token...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      print('Access Token stored.');
    } catch (error) {
      print(error);
    }
  }
}
