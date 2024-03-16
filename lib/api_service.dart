import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api/auth';

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

    if (response.statusCode == 201) {
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
}

class GoogleAuthApi {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<void> initiateGoogleAuth() async {
    final response = await http.get(Uri.parse('$baseUrl/google'));

    if (response.statusCode == 200) {
      print('Redirected to Google\'s authentication page.');
    } else {
      throw Exception('Failed to initiate Google authentication.');
    }
  }

  Future<String> handleGoogleAuthCallback() async {
    final response = await http.get(Uri.parse('$baseUrl/google/callback'));

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