import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:curio/Models/chat_details_model.dart';
import 'package:curio/Models/chat_request_model.dart';
import 'package:curio/Models/chatmodel.dart';
import 'package:http/http.dart' as http;

class ChatApiServices {
  final String _baseUrl = 'http://10.0.2.2:3000';
  // final String _baseUrl = 'http://192.168.43.158:3000';

  Future<List<Chat>> getChats(
    String token, {
    Chatfilter filter = Chatfilter.all,
  }) async {
    final url = Uri.parse('$_baseUrl/api/chat/overview/${filter.name}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Ensure valid token format
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      log(data.toString());
      List<dynamic> chatsJson = data['chats'];
      log(data['chats'].toString());

      final chats =
          chatsJson.map((chatJson) => Chat.fromJson(chatJson)).toList();

      return chats;
    } else {
      throw Exception('Failed to fetch chats: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> checkUserNameAvilability(String username) async {
    final url = Uri.parse('$_baseUrl/api/chat/checkUsername/$username');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      log(response.body);
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

//!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------
//!---------------------------------Create New Chat--------------------------------
//!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------
  Future<Map<String, dynamic>> createNewChat({
    required String username,
    required String token,
    required String message,
    String media = '',
  }) async {
    final baseUrl = _baseUrl; // Assuming this is already defined

    final url = Uri.parse('$baseUrl/api/chat/create');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'recipient': username,
      'message': message,
    });

    if (media != '') {
      try {
        request.files.add(await http.MultipartFile.fromPath('media', media));
      } on FileSystemException catch (e) {
        throw ChatCreationException(
            message: 'Failed to attach media: ${e.message}');
      }
    }

    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      log(data);
      return jsonDecode(data);
    } else if (response.statusCode == 400) {
      final data = await response.stream.bytesToString();
      log(data);
      throw ChatCreationException(message: jsonDecode(data)['message']);
    } else {
      final reasonPhrase = response.reasonPhrase ?? 'Unknown error';
      final errorMessage = response.statusCode == 400
          ? 'Bad request: ${response.reasonPhrase}'
          : 'Failed to create chat: Status code ${response.statusCode} - $reasonPhrase';
      throw ChatCreationException(message: errorMessage);
    }
  }

  //!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------
//!---------------------------------sending messga--------------------------------
//!--------------------------------------------------------------------------------
//!--------------------------------------------------------------------------------

  sendMessage({
    required String chatID,
    required String token,
    required String message,
    String media = '',
  }) async {
    final baseUrl = _baseUrl; // Assuming this is already defined

    final url = Uri.parse('$baseUrl/api/chat/send/$chatID');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'message': message,
    });

    if (media != '') {
      try {
        request.files.add(await http.MultipartFile.fromPath('media', media));
      } on FileSystemException catch (e) {
        throw ChatCreationException(
            message: 'Failed to attach media: ${e.message}');
      }
    }

    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      log(data);
      return jsonDecode(data);
    } else {
      final reasonPhrase = response.reasonPhrase ?? 'Unknown error';
      final errorMessage = response.statusCode == 400
          ? 'Bad request: ${response.reasonPhrase}'
          : 'Failed To send message: Status code ${response.statusCode} - $reasonPhrase';
      throw ChatCreationException(message: errorMessage);
    }
  }

  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  //!-----------------------------------Get all Message------------------------------
  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  // Assuming you have a function to make HTTP requests (replace with your actual implementation)
  Future<ChatDetails> getChatMessages(String chatId, String token) async {
    final url = Uri.parse('$_baseUrl/api/chat/$chatId');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString())['chat'];
    log(data.toString());

    ChatDetails chat = ChatDetails.fromJson(data[0]);
    return (chat);
  }

  void printAttributeTypes(data) {
    if (data is List) {
      for (var item in data) {
        printAttributeTypes(item); // Recursive call for nested lists
      }
    } else if (data is Map) {
      data.forEach((key, value) {
        log('Key: $key, Type: ${value.runtimeType}');
      });
    } else {
      log('Value: $data, Type: ${data.runtimeType}');
    }
  }

  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------
  //!-----------------------------Get Chat Request----------------------------------
  //!--------------------------------------------------------------------------------
  //!--------------------------------------------------------------------------------

  Future<List<dynamic>> fetchChatRequests({required String token}) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('GET', Uri.parse('$_baseUrl/api/chat/requests'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      log(jsonDecode(jsonResponse)['chatRequests'].runtimeType.toString());

      return jsonDecode(jsonResponse)['chatRequests'];
    } else {
      throw Exception('Failed to load chat requests');
    }
  }
}

enum Chatfilter { all, direct, group }

class ChatCreationException implements Exception {
  final String message;

  ChatCreationException({required this.message});

  @override
  String toString() => message;
}
