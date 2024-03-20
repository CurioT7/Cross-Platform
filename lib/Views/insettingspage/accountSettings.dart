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

class AccountSettingsPage extends StatefulWidget {
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _selectedGender = 'Man'; // Initial selected gender
  String _selectedLocation = 'No location specified';
  bool _isConnected = false;
  String _username = '';
  String _email = '';

  ApiServiceMahmoud _apiService = ApiServiceMahmoud();

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load initial data when the widget initializes
  }

  void _loadInitialData() async {
    // You can add other initializations here if needed
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      // Fetch user profile data
      Map<String, dynamic> userProfile = await _apiService.getUserProfile();
      print(userProfile); // Print the fetched data for debugging
      setState(() {
        _selectedGender = userProfile['gender'];
        _username = userProfile['username'];
        _email = userProfile['email'];
        print(_selectedGender);
        print(_username);
        print(_email);

      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

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
            subtitle: Text(_email.isNotEmpty ? _email : 'Loading...', style: kMoreInfoTextStyle),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateEmailAdressPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog, color: KIconColor),
            title: Text('Change password', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)  => ChangePasswordPage()),
              );
            },
          ),
          ListTile(
            leading: Container(
              alignment: Alignment.topLeft,
              width: 28,
              height: double.infinity,
              child: Icon(Icons.location_on_outlined, color: KIconColor,),
            ),
            title: Text('Location customization', style: kTitleHeader),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedLocation, style: kMoreInfoTextStyle, textAlign: TextAlign.left,),
                Text("Specify a location to customize your recommendations and feed. Reddit does not track your precise geolocation data.", style: kMoreInfoTextStyle,)
              ],
            ),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationCustomizationPage()),
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
            leading: Image.asset('lib/assets/images/google.png', height: 40, width: 40),
            title: Text('Google', style: kTitleHeader),
            trailing: TextButton(
              child: Text((_isConnected ? "Connect" : "Disconnect"), style: KConnectedAccountsButtonColor),
              onPressed: () {
                setState(() {
                  _isConnected = !_isConnected;
                });
                if (_isConnected) {
                  // Navigate to ConnectToGooglePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectToGooglePage()),
                  );
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
                MaterialPageRoute(builder: (context) => BlockedAccountsPage()),


              );
            },
          ),
        ],
      ),
    );
  }
}
