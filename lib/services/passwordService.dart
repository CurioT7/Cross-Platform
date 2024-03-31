import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordService {
  final String baseUrl = 'http://192.168.1.3:3000/api/auth';

  Future<http.Response> requestPasswordReset(String username, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email}),
    );

    return response;
  }

  Future<http.Response> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset_password/$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'password': newPassword}),
    );

    return response;
  }
}