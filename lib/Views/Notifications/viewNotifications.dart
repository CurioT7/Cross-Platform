import 'package:flutter/material.dart';
import 'package:curio/Views/sidebars/CustomSidebar.dart';
import 'package:curio/Views/sidebars/sidebarAfterlogin.dart';

import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../new_message_screen.dart';
import 'notificationCard.dart';
import 'notificationModel.dart';

class ViewNotifications extends StatefulWidget {
  const ViewNotifications({super.key});

  @override
  _ViewNotificationsState createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomSidebar()),
            );
          },
        ),
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewMessageScreen()),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SidebarAfterLogIn()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/Curio.png'),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.grey[800],
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Replace with your Notifications and Messages pages
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<NotificationModel>>(
                future: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? token = prefs.getString('token');
                  if (token == null) {
                    throw Exception('Token is null');
                  }
                  return logicAPI().getAllNotifications(token);
                }(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<NotificationModel>> snapshot) {
                  if (snapshot.hasData) {
                    List<NotificationModel> notifications = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        print(
                            'Notification ${index + 1}: ${notifications[index].message}');
                        return NotificationCard(
                          notification: notifications[index],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(color: Colors.blue),
        ],
      ),
    );
  }
}
