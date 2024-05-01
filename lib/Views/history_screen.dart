import 'package:curio/Models/post.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:flutter/material.dart';

import '../widgets/recent_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int votes = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('History'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecentWidget(),
          PostCard(
            post: Post(
              id: '661b22c0800e2136153309c3',
              title: 'WHAT IS THIS',
              content:
              'Introducing lesser-known indie rock bands and albums that deserve more recognition, along with discussions on the evolution of the genre.',
              authorName: 'senawy',
              views: 657,
              createdAt: DateTime.parse('2024-04-14T00:26:40.995Z'),
              upvotes: 1,
              downvotes: 0,
              linkedSubreddit: '6615aaa2579c935be547895d',
              comments: [],
              shares: 0,
              isNSFW: false,
              isSpoiler: false,
              isOC: false,
              isCrosspost: false,
              awards: 0,
              media: '',
              link: '',
              isDraft: false,
            ),
          ),
        ],
      ),
    );
  }
}
