import 'package:flutter/material.dart';

import 'package:curio/utils/constants.dart';


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
import 'package:curio/utils/componentUserInfoSubAppBar.dart';

class ChooseCommunityPage extends StatefulWidget {
  @override
  _ChooseCommunityPageState createState() => _ChooseCommunityPageState();
}

class _ChooseCommunityPageState extends State<ChooseCommunityPage> {
  String _username = '';
  String _email = '';
  final ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  List<dynamic> communities=[];




  @override
  void initState() {
    super.initState();
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
    print(userProfile);
    setState(() {

      _username = userProfile['username'];
      print('username in the select page is');
      print(_username);

            _email = userProfile['email'];


    });
    _fetchUserCommunities(token);
  } catch (e) {
    print('Failed to fetch user profile: $e');
  }
}

  void _fetchUserCommunities(token) async {
    try {
        print(token);

      if (token == null) {
        throw Exception('Token not found');
      }
      // Replace 'token' with the actual token obtained from somewhere



      Map<String, dynamic> userCommunities = await _apiService.getUserCommunities(   token, _username);
      setState(() {
        communities = userCommunities['communities'];
        print(communities);
      }
      );
    } catch (e) {
      print('Failed to fetch user communities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(title: 'Choose a Community'),
      body: ListView(
        children: [
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('profile', style: kSubtitleTextStyle),
            ),
          ),
          UserInfoSubBar(),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('joined', style: kSubtitleTextStyle),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: communities == null ? 0 : communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset('lib/assets/images/Curio.png'),
                    radius: 30,
                  ),
                  title: Text(community['name']),

                  onTap: () {
                    // Handle community selection
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
