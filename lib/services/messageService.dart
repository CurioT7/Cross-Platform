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
    print('Getting token...');
    final token = await getToken();
    print('Token: $token');

    print('Sending GET request...');
    final response = await http.get(
      Uri.parse('$baseUrl/sent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Parsing response...');
      List data = jsonDecode(response.body)['messages'];
      print('Parsed data: $data');

      print('Converting data to messages...');
      List<Message> messages = data.map((item) => Message.fromJson(item)).toList();
      print('Converted messages: $messages');

      return messages;
    } else {
      print('Failed to load messages');
      throw Exception('Failed to load messages');
    }
  }
Future<Map<String, dynamic>> sendMessage({
  required String recipient,
  required String subject,
  required String message,
  bool sendToSubreddit = false,
  String? subreddit,
}) async {
  final token = await getToken();
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

  return jsonDecode(response.body);
}
  Future<List<Message>> getInboxMessages(String type) async {
    print('Getting token...');
    final token = await getToken();
    print('Token: $token');

    print('Sending GET request to $baseUrl/inbox/$type...');
    final response = await http.get(
      Uri.parse('$baseUrl/inbox/$type'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Parsing response...');
      List data = jsonDecode(response.body)['messages'];
      print('Parsed data: $data');

      print('Converting data to messages...');
      List<Message> messages = data.map((item) => Message.fromJson(item)).toList();
      print('Converted messages: $messages');

      return messages;
    } else {
      print('Failed to load messages');
      throw Exception('Failed to load messages');
    }
  }
  Future<Map<String, dynamic>> markAllAsRead() async {
    print('Mark all as read started');
    final token = await getToken();
    print('Token: $token');
    final response = await http.post(
      Uri.parse('$baseUrl/readAll'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return jsonDecode(response.body);
  }
}