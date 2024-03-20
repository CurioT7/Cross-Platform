import 'package:flutter/material.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class BlockedAccountsPage extends StatefulWidget {
  @override
  _BlockedAccountsPageState createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  List<String> blockedAccounts = [
    "mahmoud 1",
    // Add more blocked accounts here...
  ];

  List<String> allAccounts = [
    "mahmoud 1",
    "User 2",
    "User 3",
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
            .where((account) => account.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _blockAccount(String account) {
    setState(() {
      blockedAccounts.add(account);
      // Optionally filter the accounts again to reflect changes
      _filterAccounts('');
      printBlockedAccounts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Set behavior to floating to allow padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.green,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Add margin to the left and right
          child: Container(
            height: 40, // Adjust the height as needed
            alignment: Alignment.center, // Center the text horizontally
            child: Text(' User has been blocked.'),
          ),
        ),
      ),
    );
  }


  void _unblockAccount(String account) {
    setState(() {
      blockedAccounts.remove(account);
      // Optionally filter the accounts again to reflect changes
      _filterAccounts('');
      printBlockedAccounts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Set behavior to floating to allow padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.green,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Add margin to the left and right
          child: Container(
            height: 40, // Adjust the height as needed
            alignment: Alignment.center, // Center the text horizontally
            child: Text(' User has been unblocked.'),
          ),
        ),
      ),
    );
  }

  void printBlockedAccounts() {
    print("Blocked Accounts: $blockedAccounts");
  }
}
