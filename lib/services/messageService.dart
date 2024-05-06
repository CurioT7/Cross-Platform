import 'dart:convert';
import 'package:curio/Models/message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.13:3000/api/message';

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<List<Message>> getSentMessages() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/sent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['messages'];
      return data.map((item) => Message.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

Future<String> sendMessage({
  required String recipient,
  required String subject,
  required String message,
  bool sendToSubreddit = false,
  String? subreddit,
}) async {
  final token = await getToken();
  print('Token: $token'); // Print the token

  final response = await http.post(
    Uri.parse('$baseUrl/compose'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'recipient': recipient,
      'subject': subject,
      'message': message,
      'sendToSubreddit': sendToSubreddit,
      'subreddit': subreddit,
    }),
  );

  print('Response status: ${response.statusCode}'); // Print the response status
  print('Response body: ${response.body}'); // Print the response body

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['success']) {
      return 'Message sent successfully!';
    } else {
      return jsonDecode(response.body)['message'];
    }
  } else {
    throw Exception('Failed to send message');
  }
}

  Future<List<Message>> getInboxMessages(String type) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/inbox/$type'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['messages'];
      return data.map((item) => Message.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}