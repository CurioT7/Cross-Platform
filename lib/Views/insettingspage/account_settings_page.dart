import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curio/utils/constants.dart';
import 'package:curio/views/insettingspage/blocked_accounts_page.dart';
import 'package:curio/views/insettingspage/change_password_page.dart';
import 'package:curio/views/insettingspage/location_customization_page.dart';
import 'package:curio/views/insettingspage/update_email_adress_page.dart';
import 'package:curio/utils/component_app_bar.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _selectedGender = 'Man'; // Initial selected gender
  String _selectedLocation= 'No location specified';
  bool _isConnected = false;

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Man'),
              onTap: () {
                setState(() {
                  _selectedGender = 'Man'; // Update the gender state
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Woman'),
              onTap: () {
                setState(() {
                  _selectedGender = 'Woman'; // Update the gender state
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: ComponentAppBar(title: 'Account Settings',),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email, color: KIconColor),
            title: Text('Update email address', style: kSubtitleTextStyle),
            subtitle: Text('mahmoud9salah2002@gmail.com', style: kMoreInfoTextStyle),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateEmailAdressPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: KIconColor),
            title: Text('Change password', style: kSubtitleTextStyle),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: KIconColor),
            title: Text('Location customization', style: kSubtitleTextStyle),
            subtitle: Text(_selectedLocation), // Display selected location or default text
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationCustomizationPage()),
              );
              setState(() {
                _selectedLocation = selectedLocation; // Update the selected location
              });
            },
          ),

          ListTile(
            leading: Icon(Icons.person, color: KIconColor),
            title: Text('Gender', style: kSubtitleTextStyle),
            subtitle: Text(_selectedGender),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: _showGenderBottomSheet, // Call the bottom sheet method
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Connected Accounts', style: kSubtitleTextStyle),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.google, color: KIconColor),
            title: Text('Google', style: kSubtitleTextStyle),
            trailing: TextButton(
              child: Text((_isConnected?"Connect":"Disconnect"), style: KConnectedAccountsButtonColor),
              onPressed: () {
                setState(() {
                        _isConnected = !_isConnected;
              });
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('SAFETY'),
          ),
          ListTile(
            leading: Icon(Icons.block, color: KIconColor),
            title: Text('Manage blocked accounts', style: kSubtitleTextStyle),
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
