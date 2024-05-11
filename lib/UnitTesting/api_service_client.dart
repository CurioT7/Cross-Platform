import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';

class MockApiService extends ApiService {
  final http.Client client;
  final String _baseUrl = 'http://10.0.2.2:3000';

  MockApiService({required this.client});

  @override
  Future<http.Response> signIn(String usernameOrEmail, String password) async {
    final response = await client.post(
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

  Future<Map<String, dynamic>> changeEmail(
      String newEmail, String password, String token) async {
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
      final response = await http.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Edit the success message here
        String editedMessage =
            "Your email has been successfully changed to $newEmail. Please verify your new email address.";
        return {'success': true, 'message': editedMessage};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

}