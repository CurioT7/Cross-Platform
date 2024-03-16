import 'dart:convert';
import 'package:http/http.dart' as http;

class MockApiService {
  Future<http.Response> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // Check the credentials (you can define your own logic here)
    if (email == 'test@example.com' && password == '123') {
      // Simulate a successful response with a mock token
      var response = {
        'token': 'mock-token',
        'user': {
          'id': '1',
          'name': 'John Doe',
          'email': 'test@example.com',
        },
      };
      return http.Response(jsonEncode(response), 200);
    } else {
      // Simulate an error response
      var response = {
        'error': 'Invalid credentials',
      };
      return http.Response(jsonEncode(response), 400);
    }
  }
}
