import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curio/UnitTesting/api_service_client.dart';
// Import your ApiService class
import 'package:curio/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate mocks for ApiService and http.Client
@GenerateMocks([MockApiService, http.Client])

void main() {
  group('signIn', () {
    test('returns http response when the call completes successfully', () async {
      // Create a mock http.Client
      final client = MockClient((request) async {
        // Check the request URL and provide a mock response accordingly
        if (request.url.path == '/api/auth/app/login') {
          // Return a successful response for login request
          return http.Response(
              '{"success":true,"message":"Login successful","accessToken":"token"}',
              200);
        } else {
          // Return a not found response for other paths
          return http.Response('{"error":"Not Found"}', 404);
        }
      });

      // Create an instance of ApiService
      final apiService = MockApiService(client: client);
     // final apiService = ApiService();

      // Define test data
      final String usernameOrEmail = 'testUser2';
      final String password = 'test1234';

      // Call the signIn method of ApiService
      final response = await apiService.signIn(usernameOrEmail, password);

      // Assert the response
      expect(response.statusCode, equals(200));
      final responseBody = jsonDecode(response.body);
      expect(responseBody.containsKey('accessToken'), equals(true));


      // final prefs = MockSharedPreferences();
      //
      // // Use when().thenAnswer() to define the behavior of the mock
      // when(prefs.setString('token', responseBody['accessToken']))
      //     .thenAnswer((_) async => true);
      //
      // // Use the mock in your test
      // final result = await prefs.setString('token', responseBody['accessToken']);
      // expect(result, equals(true));

    });
  });


//   group('changeEmail', () {
//     test('returns http response when the call completes successfully', () async {
//       // Create a mock http.Client
//       final client = MockClient((request) async {
//         // Check the request URL and provide a mock response accordingly
//         if (request.url.path == '/api/auth/change_email') {
//           // Return a successful response for change email request
//           return http.Response(
//               '{"success":true,"message":"Your email has been successfully changed to new_email@example.com. Please verify your new email address."}',
//               200);
//         } else {
//           // Return a not found response for other paths
//           return http.Response('{"error":"Not Found"}', 404);
//         }
//       });
//
//       // Create an instance of ApiService
//       final apiService = MockApiService(client: client);
//       // final apiService = ApiService();
//
//       // Define test data
//       final String newEmail = 'yaraihab2@gmail.com';
//       final String password = 'test1234';
//
//       // Call the changeEmail method of ApiService
//       final prefs = MockSharedPreferences();
//       final token = prefs.getString('token');
//       final response = await apiService.changeEmail(newEmail, password, token!);
//
//       // Assert the response
//       expect(response['success'], equals(true));
//       expect(
//           response['message'],
//           equals(
//               'Your email has been successfully changed to new_email@example.com. Please verify your new email address.'));
//     });
//   });
 }

//class MockSharedPreferences extends Mock implements SharedPreferences {}
