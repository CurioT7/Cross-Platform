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