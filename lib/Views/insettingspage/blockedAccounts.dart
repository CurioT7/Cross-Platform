import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedAccountsPage extends StatefulWidget {
  @override
  _BlockedAccountsPageState createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
List<dynamic> blockedAccounts = [];

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

      print('blocked accounts are $blockedAccounts');

  }

  void _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('token');

    print('the value of the token inside the settings page is  $value');


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
      blockedAccounts= userPref['viewBlockedPeople'];
      print('blocked accounts are $blockedAccounts');
      print('$userPref'); // Print the fetched data for debugging


      setState(() {
        blockedAccounts= userPref['viewBlockedPeople'];


      });
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

  final ApiServiceMahmoud _apiService = ApiServiceMahmoud();



  List<dynamic> filteredAccounts = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(title: 'Blocked Accounts'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _filterAccounts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blockedAccounts.length,
              itemBuilder: (context, index) {
                String account = blockedAccounts[index]['blockedUsername'];


                return ListTile(
                  leading: CircleAvatar(
                    // Replace with user's actual avatar if available
                    child: Icon(Icons.person),
                  ),
                  title: Text(account),
                  trailing: ElevatedButton(
                    onPressed: () {
                      //_blockAccount(account);
                      _unblockAccount(account);
                      _loadInitialData();
                    },
                    child: Text('unblock'),
                    style: ElevatedButton.styleFrom(
                      //primary: isBlocked ? Colors.blue : Colors.red,
                      //onPrimary: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterAccounts(String query) {
    if (query.isEmpty) {
      setState(() {
        blockedAccounts = blockedAccounts;
      });
    } else {
      setState(() {

      });
    }
  }

  void _blockAccount(String account) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _apiService.blockUser(token,account);
      if (response['message'] == 'User successfully blocked') {
        setState(() {
          blockedAccounts.add(account);
          _filterAccounts('');
          printBlockedAccounts();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            backgroundColor: Colors.green,
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text('User has been blocked.'),
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            backgroundColor: Colors.red,
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text('Failed to block user: ${response['message']}'),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Colors.red,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Failed to block user: $e'),
            ),
          ),
        ),
      );
    }
  }

  void _unblockAccount(String account) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (token != null) {
        final response = await _apiService.unblockUser(token, account);
        if (response['message'] == 'User successfully unblocked')
        {
          setState(() {
            blockedAccounts.remove(account);
            _filterAccounts('');
            printBlockedAccounts();

          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              backgroundColor: Colors.green,
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('User has been unblocked.'),
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              backgroundColor: Colors.red,
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Failed to unblock user: ${response['message']}'),
                ),
              ),
            ),
          );
        }
      } else {
        // Handle case where token is null
        print('Token is null');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Colors.red,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Failed to unblock user: $e'),
            ),
          ),
        ),
      );
    }
  }

  void printBlockedAccounts() {
    print('Blocked Accounts: $blockedAccounts');
  }
}
