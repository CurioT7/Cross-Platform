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

class AccountSettingsPage extends StatefulWidget {
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
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
  String _selectedLocation = 'Mexico';
  bool _isConnected = false;
  String _username = '';
  String _email = '';

  ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
    _loadInitialData(); // Load initial data when the widget initializes
  }

  void _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('token');


    print('the value of the token inside the settings page is  $value');
    String? initialGender = prefs.getString('selectedGender');
    if (initialGender != null) {
      setState(() {
        _selectedGender = initialGender;
      });
    }
    _fetchUserProfile();
  }


  void _fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, dynamic> userProfile =
          await _apiService.getUserProfile(token);
      print(userProfile); // Print the fetched data for debugging
      // Fetch user preferences

      Map<String, dynamic> userPref =
          await _apiService.getUserPreferences(token);

      print('$userPref'); // Print the fetched data for debugging

      setState(() {
        _selectedLocation = userPref['locationCustomization'];
        print('the value of the selected location is $_selectedLocation');
        print('the value of the connected to google is $_isConnected');
        _createdPassword = userProfile['createdPassword'] ?? true;
        print('the value of the created password is $_createdPassword');
        _selectedGender = userPref['gender'] ?? 'N/A';
        _username = userProfile['username'];
        _email = userProfile['email'];
        _isConnected = userProfile['connectedToGoogle'] ?? true;

        print(userProfile['connectedToGoogle']);
      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: ComponentAppBar(title: 'Account Settings'),
      body: ListView(
        children: <Widget>[
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Basic Settings', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog, color: KIconColor),
            title: Text('Update email address', style: kTitleHeader),
            subtitle: Text(_email.isNotEmpty ? _email : 'Loading...',
                style: kMoreInfoTextStyle),
            subtitle: Text(_email.isNotEmpty ? _email : 'Loading...',
                style: kMoreInfoTextStyle),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              if (_createdPassword) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateEmailAdressPage()),
                ).then((_) {
                  _fetchUserProfile();
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog, color: KIconColor),
            title: Text('Change password', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              if (!_createdPassword) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              }
            },
          ),
          ListTile(
            leading: Container(
              alignment: Alignment.topLeft,
              width: 28,
              height: double.infinity,
              child: Icon(
                Icons.location_on_outlined,
                color: KIconColor,
              ),
            ),
            title: Text('Location customization', style: kTitleHeader),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedLocation,
                  style: kMoreInfoTextStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Specify a location to customize your recommendations and feed. Reddit does not track your precise geolocation data.",
                  style: kMoreInfoTextStyle,
                )
              ],
            ),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationCustomizationPage()),
              );
              setState(() {
                _selectedLocation = selectedLocation;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outlined, color: KIconColor),
            title: Text('Gender', style: kTitleHeader),
            subtitle: Text(_selectedGender, style: kMoreInfoTextStyle),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              showGenderBottomSheet(context, (String gender) {
                setState(() {
                  _selectedGender = gender;
                });
              });
            },
          ),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Connected Accounts', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Image.asset('lib/assets/images/google.png',
                height: 40, width: 40),
            title: Text('Google', style: kTitleHeader),
            trailing: TextButton(
              child: Text((_isConnected == false ? "Connect" : "Disconnect"),
                  style: KConnectedAccountsButtonColor),
              onPressed: () {
                if (_isConnected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmPasswordPage()),
                  );
                } else {
                  _signInWithGoogle();
                }
              },
            ),
          ),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('SAFETY', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.ban, color: KIconColor),
            title: Text('Manage blocked accounts', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlockedAccountsPage()),
              );
            },
          ),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('CONTACT SETTINGS', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bell, color: KIconColor),
            title: Text('Manage Notifications', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle() async {
    print("Connecting with Google...");

    await GoogleSignIn().signOut();
    UserCredential? userCredential =
        await googleAuthSignInService.signInWithGoogle();
    if (userCredential != null) {
      String? accessToken = userCredential.credential?.accessToken;
      print('The access token is $accessToken');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      try {
        var response =
            await _apiService.connectWithGoogle(token!, accessToken!);
        if (response['success']) {
          setState(() {
            _isConnected = true;
            _showSnackBar(response['message']);
          });
        } else {
          _showSnackBar(response['message']);
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}
