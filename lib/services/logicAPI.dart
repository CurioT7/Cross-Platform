import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class logicAPI {
  final String _baseUrl = 'http://10.0.2.2:3000';// Replace with your backend URL

  Future<Map<String, dynamic>> fetchUserData( String username ) async {
    final response = await http.get( Uri.parse('$_baseUrl/user/$username/about'),   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);


    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Map<String, dynamic> extractUserDetails(Map<String, dynamic> userData) {
    return {
      'postKarma': userData['postKarma'],
      'commentKarma': userData['commentKarma'],
      'cakeDay': userData['cakeDay'],
    };
  }

  Future<Map<String, dynamic>> fetchUsername( String token ) async {
    print (token);
    final response = await http.get( Uri.parse('$_baseUrl/api/settings/v1/me'),   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },);


    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }
  Map<String, dynamic> extractUsername(Map<String, dynamic> userData) {
    return {
      'username': userData['username'],

    };
  }
  Future<int> daysSinceCakeDay(Map<String, dynamic> userDetails) async {
    final String cakeDay = userDetails['cakeDay']; // Assuming the cakeDay is in the format "Mar 2, 2024"
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final DateTime cakeDayDate = formatter.parse(cakeDay);
    final DateTime currentDate = DateTime.now();

    final int daysDifference = currentDate.difference(cakeDayDate).inDays;
    print("date hereeeeeeeeeeeeee");
    print( daysDifference);
    return daysDifference;

  }

  // Future<Map<String, dynamic>>  createCommunity( String communityName, String typeCommunity, bool isOver18, String token) async {
  //
  //
  //   final response = await http.post(Uri.parse('$_baseUrl/api/createSubreddit'),  headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   },
  //     body: jsonEncode(<String, String>{
  //       'name': communityName,
  //       'description': 'none' ,
  //       'over18': isOver18.toString() ,
  //       'privacyMode': typeCommunity.toLowerCase(),
  //     }),);
  //
  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else if (response.statusCode == 404) {
  //     throw Exception('User not found');
  //   } else if (response.statusCode == 500) {
  //     throw Exception('Internal Server Error');
  //   } else {
  //     throw Exception('Unexpected error occurred');
  //   }
  // }
  Future<Map<String, dynamic>> createCommunity(String communityName, bool isOver18, String typeCommunity, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/createSubreddit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'name': communityName,
          'description': 'none',
          'over18': isOver18,
          'privacyMode': typeCommunity.toLowerCase(),
        }),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 404) {
          throw Exception('User not found');
        } else if (response.statusCode == 500) {
          throw Exception('Internal Server Error');
        } else {
          throw Exception('Unexpected error occurred');
        }
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error creating community: $e');
    }
  }
}
