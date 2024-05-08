import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.13:3000/api';

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<dynamic> banUser(String subredditName, String userToBan, String violation, String modNote, String userMessage) async {
    print('Ban user method called with:');
    print('Subreddit name: $subredditName');
    print('User to ban: $userToBan');
    print('Violation: $violation');
    print('Mod note: $modNote');
    print('User message: $userMessage');

    String token = await getToken();
    print('Token: $token');

    var response = await http.post(
      Uri.parse('$baseUrl/moderator/ban'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'subredditName': subredditName,
        'userToBan': userToBan,
        'violation': violation,
        'modNote': modNote,
        'userMessage': userMessage,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return jsonDecode(response.body);
  }

  Future<dynamic> unbanUser(String subredditName, String bannedUser) async {
    String token = await getToken();
    var response = await http.post(
      Uri.parse('$baseUrl/moderator/unban'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'subredditName': subredditName,
        'bannedUser': bannedUser,
      }),
    );
    print(response.body);
    return jsonDecode(response.body);
  }

  Future<dynamic> getBannedUsers(String subredditName) async {
    String token = await getToken();
    print('Token: $token');

    var response = await http.get(
      Uri.parse('$baseUrl/r/$subredditName/about/banned'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    var decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}