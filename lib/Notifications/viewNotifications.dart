import 'package:curio/Models/message.dart';
import 'package:curio/Views/Messages/messages_list.dart';
import 'package:curio/Views/Messages/pop_up_menu.dart';
import 'package:curio/services/messageService.dart';
import 'package:curio/widgets/messege_card.dart';
import 'package:flutter/material.dart';
import 'package:curio/Views/sidebars/CustomSidebar.dart';
import 'package:curio/Views/sidebars/sidebarAfterlogin.dart';
import 'package:curio/Notifications/notificationCard.dart';
import 'package:curio/Notifications/notificationModel.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewNotifications extends StatefulWidget {
  @override
  _ViewNotificationsState createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // void onNotificationHidden() {
  //   setState(() {});
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Notification is hidden'),
  //       action: SnackBarAction(
  //         label: 'UNDO',
  //         textColor: Colors.blue,
  //         onPressed: () {
  //
  //
  //         },
  //       ),
  //     ),
  //   );
  // }

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
          CustomPopupMenuButton(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SidebarAfterLogIn()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/Curio.png'),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.grey[800],
          tabs: [
            Tab(text: 'Notifications'),
            Tab(text: 'Messages'),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<NotificationModel>>(
                  future: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');
                    if (token == null) {
                      throw Exception('Token is null');
                    }
                    return logicAPI().getAllNotifications(token);
                  }(),
                  builder: (BuildContext context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                    if (snapshot.hasData) {
                      List<NotificationModel> notifications = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: notifications.length ,
                        itemBuilder: (context, index) {
                          print('Notification ${index + 1}: ${notifications[index].message}');
                          // return NotificationCard(
                          //   key: ValueKey(notifications[index].id),
                          //   notification: notifications[index],
                          //   onHidden: () {
                          // setState(() {});
                          //
                          // },
                          // );

                          return NotificationCard(
                            key: ValueKey(notifications[index].id),
                            notification: notifications[index],
                            onHidden: () {
                              setState(() {
                                notifications.remove(notifications[index]);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Notification is hidden'),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
         MessagesList(),
        ],
      ),
    );
  }
}