import 'package:curio/services/ahmed_api.dart';
import 'package:flutter/material.dart';

import 'block_dialog.dart';
import 'report_bootom_sheet.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, this.isUser = false});

  final bool isUser;

  void _showReportProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ReportBottomSheet(),
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BlockDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        Visibility(
          visible: isUser,
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                _showReportProfileDialog(context);
              } else if (value == 'block') {
                _showBlockDialog(context);
              } else {}
            },
            iconColor: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'message',
                  child: Text('Send a Message'),
                ),
                const PopupMenuItem(
                  value: 'custom_feed',
                  child: Text('Add to Custom Feed'),
                ),
                const PopupMenuItem(
                  value: 'block',
                  child: Text('Block'),
                ),
                const PopupMenuItem(
                  value: 'report',
                  child: Text('Report Profile'),
                ),
              ];
            },
          ),
        ),
      ],
      expandedHeight: isUser
          ? MediaQuery.sizeOf(context).height * 0.35
          : MediaQuery.sizeOf(context).height * 0.5,
      flexibleSpace: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0077D6),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('lib/assets/images/avatar.jpeg'),
            ),
            const SizedBox(height: 12.0),
            Visibility(
              visible: !isUser,
              replacement: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ApiService().followUser('');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: const Text('Follow'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      shape: const CircleBorder(
                        // borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.message,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Middle_Mall8968',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'u/Middle_Mall8968 - 1 karma - Mar 26, 2024',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            if (!isUser) ...[
              const Text(
                '0 Gold',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  foregroundColor: Colors.white,
                ),
                child: const Text('+ Add social link'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
