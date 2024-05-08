
import 'package:curio/Views/insettingspage/notificationSettings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curio/utils/constants.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/views/insettingspage/connectedAccounts.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:curio/Views/moderator/moderators.dart';

class ModeratorToolsPage extends StatefulWidget {
  final String subredditName;
  const ModeratorToolsPage({Key? key, required this.subredditName}) : super(key: key);
  @override
  State<ModeratorToolsPage> createState() => _ModeratorToolsPageState();
}

class _ModeratorToolsPageState extends State<ModeratorToolsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    print('Subreddit name: ${widget.subredditName}');
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

      Map<String, dynamic> userPref = await _apiService.getUserPreferences(token);

      print('$userPref'); // Print the fetched data for debugging


      setState(() {

      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: ComponentAppBar(title: 'Moderator Tools Page'), // Change the title here
      body: ListView(
        children: <Widget>[
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('GENERAL', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit , color: KIconColor),
            title: Text('Description', style: kTitleHeader),

            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {


            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: KIconColor),
            title: Text('Community type', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {


            },
          ),
          ListTile(
            leading: Icon(Icons.library_books , color: KIconColor),
            title: Text('Post types', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {


            },
          ),

          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('CONTENT & REGULATIONS', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description, color: KIconColor),
            title: Text('Rules', style: kTitleHeader),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: KIconColor),
            title: Text('Scheduled posts', style: kTitleHeader),
            onTap: () {

            },
          ),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('USER MANAGEMENT', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined, color: KIconColor),
            title: Text('Moderators', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              String subredditName = 'dynamicSubredditName'; // Set your dynamic subreddit name here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModeratorsPage(subredditName: widget.subredditName ),
                ),
              );
            },
          ), // Removed the extra closing parenthesis here

          ListTile(
            leading: Icon(Icons.person_outline, color: KIconColor),
            title: Text('Approved users', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.gavel_outlined, color: KIconColor),
            title: Text('Banned users', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {

            },
          ),

        ],
      ),
    );
  }
}