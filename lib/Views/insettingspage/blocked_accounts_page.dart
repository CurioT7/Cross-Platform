import 'package:flutter/material.dart';
import 'package:curio/utils/component_app_bar.dart';

class BlockedAccountsPage extends StatefulWidget {
  @override
  _BlockedAccountsPageState createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  List<String> blockedAccounts = [
    "mahmoud 1",
    "User 2",
    "User 3",
    // Add more blocked accounts here...
  ];

  List<String> filteredAccounts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(title: 'Manage Blocked Accounts'),
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
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAccounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredAccounts[index]),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _unblockAccount(filteredAccounts[index]);
                    },
                    child: Text('Unblock'),
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
    setState(() {
      filteredAccounts = blockedAccounts
          .where((account) => account.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _unblockAccount(String account) {
    // Implement unblocking logic here
    setState(() {
      // Remove the account from the blockedAccounts list
      blockedAccounts.remove(account);
      // Also remove it from the filteredAccounts list if it exists there
      filteredAccounts.remove(account);
    });
  }
}
