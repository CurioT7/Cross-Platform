import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedAccountsPage extends StatefulWidget {
  @override
  _BlockedAccountsPageState createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  final ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  List<String> blockedAccounts = [
    "mahmoud 1",
    // Add more blocked accounts here...
  ];

  List<String> allAccounts = [
    "mahmoud1",
    "Arianna.Gutkowski53",
    'Weldon_Weissnat74',
    'Mayra.Rau',
    // Add all user accounts here...
  ];

  List<String> filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    filteredAccounts = blockedAccounts;
  }

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
              itemCount: filteredAccounts.length,
              itemBuilder: (context, index) {
                String account = filteredAccounts[index];
                bool isBlocked = blockedAccounts.contains(account);

                return ListTile(
                  leading: CircleAvatar(
                    // Replace with user's actual avatar if available
                    child: Icon(Icons.person),
                  ),
                  title: Text(account),
                  trailing: ElevatedButton(
                    onPressed: () {
                      if (isBlocked) {
                        _unblockAccount(account);
                      } else {
                        _blockAccount(account);
                      }
                    },
                    child: Text(isBlocked ? 'Unblock' : 'Block'),
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
        filteredAccounts = blockedAccounts;
      });
    } else {
      setState(() {
        filteredAccounts = allAccounts
            .where((account) =>
                account.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _blockAccount(String account) async {
    try {
      final response = await _apiService.blockUser(account);
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
        if (response['message'] == 'User successfully unblocked') {
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
