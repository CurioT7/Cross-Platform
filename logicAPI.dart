import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class logicAPI {
  final String _baseUrl = 'https://user1710617040021.requestly.tech'; // Replace with your backend URL

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

  Future<int> daysSinceCakeDay(Map<String, dynamic> userDetails) async {
    final String cakeDay = userDetails['cakeDay']; // Assuming the cakeDay is in the format "Mar 2, 2024"
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final DateTime cakeDayDate = formatter.parse(cakeDay);
    final DateTime currentDate = DateTime.now();

    final int daysDifference = currentDate.difference(cakeDayDate).inDays;
    return daysDifference;
  }

  Future<Map<String, dynamic>>  createCommunity( String communityName, String typeCommunity, bool isOver18, String token) async {


    final response = await http.post(Uri.parse('$_baseUrl/api/createSubreddit'),  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
    'name': communityName,
      'description': 'none' ,
    'over18': isOver18.toString() ,
    'privacyMode': typeCommunity.toLowerCase(),
    }),);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

}