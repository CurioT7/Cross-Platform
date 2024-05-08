import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/utils/componentUserInfoSubAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/services/api_service.dart';
import 'package:curio/Views/insettingspage/notificationSettings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curio/utils/constants.dart';
import 'package:curio/views/insettingspage/blockedAccounts.dart';
import 'package:curio/views/insettingspage/ChangePassword.dart';
import 'package:curio/views/insettingspage/locationCustomization.dart';
import 'package:curio/views/insettingspage/updateEmailAdress.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/views/insettingspage/genderPopUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/views/insettingspage/connectedAccounts.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/views/insettingspage/updateEmailAdress.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:curio/utils/helpers.dart';
import 'package:curio/utils/reddit_colors.dart';
import 'package:curio/Views/signIn/signIn.dart';
import 'package:curio/Views/signUp/userName.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curio/Views/signIn/forgotPassword.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:curio/Views/insettingspage/confirmPassword.dart';
import 'package:curio/Views/community/chooseCommunity.dart';
import 'package:curio/Views/share/shareToProfile.dart';
import 'package:curio/Views/share/shareToSubreddit.dart';
import 'package:curio/Views/insettingspage/comfirmPasswordForsignIn.dart';

class ConfirmPasswordPageSignIn extends StatefulWidget {
  @override
  State<ConfirmPasswordPageSignIn> createState() => _ConfirmPasswordPageSignInState();
}

class _ConfirmPasswordPageSignInState extends State<ConfirmPasswordPageSignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final GoogleAuthSignInService googleAuthSignInService =
  GoogleAuthSignInService();
  bool validEmail = false;
  bool _createdPassword = false;
  bool validPassword = false;
  final storage = FlutterSecureStorage();
  String _selectedGender = 'Man'; // Initial selected gender
  String _selectedLocation = 'Mexico';
  bool _isConnected = false;
  String _username = '';
  String _email = '';

  ApiServiceMahmoud _apiService = ApiServiceMahmoud();

  bool _obscureText = true;

  void _validateAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String password = _passwordController.text.trim();

    if (!_isValidPassword(password)) {
      _showSnackBar('Password should be at least 8 characters.');
      return;
    }

    if (token == null) {
      _showSnackBar('Token is null. Please log in again.');
      return;
    }

  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Add your initialization code here
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSubBar(),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
              obscureText: _obscureText,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                _validateAndSave()  ;
                print('password: ${_passwordController.text.trim()}');
                _signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
  void _signInWithGoogle() async {
    print("Connecting with Google...");
    print('password: ${_passwordController.text.trim()}');
    String password = _passwordController.text.trim();
    await GoogleSignIn().signOut();
    UserCredential? userCredential = await googleAuthSignInService.signInWithGoogle();
    if (userCredential != null) {
      String? accessToken = userCredential.credential?.accessToken;
      print('The access token is $accessToken');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      try {
        if (token == null) {
          throw Exception('Token not found');
        }

         Map<String, dynamic> response = await _apiService.connectWithGoogle(password, token, accessToken!);
        print('Response: $response');
        if (response['success']) {
          _showSnackBar('Google account connected successfully');
        } else {
          _showSnackBar(response['message']);
        }


      } catch (e) {
        print('Error: $e');
      }
    }
  }
}
