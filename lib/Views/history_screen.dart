import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:curio/Models/post.dart';
import 'package:curio/controller/history_cubit/history_cubit.dart';
import 'package:curio/widgets/empty_widget.dart';
import 'package:curio/widgets/postCard.dart';

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
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          final HistoryCubit historyCubit = context.read<HistoryCubit>();
          final List posts = historyCubit.posts;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RecentWidget(),
              Expanded(
                child: state is GetLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : historyCubit.posts.isEmpty
                        ? const EmptyWidget()
                        : ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PostCard(
                                post: Post(
                                  id: posts[index]['_id'],
                                  title: posts[index]['title'],
                                  content: posts[index]['content'],
                                  authorName: posts[index]['authorName'],
                                  views: posts[index]['views'],
                                  createdAt:
                                      DateTime.parse(posts[index]['createdAt']),
                                  upvotes: posts[index]['upvotes'],
                                  downvotes: posts[index]['downvotes'],
                                  linkedSubreddit: posts[index]
                                      ['linkedSubreddit'],
                                  comments: posts[index]['comments'],
                                  shares: posts[index]['shares'],
                                  isNSFW: posts[index]['isNSFW'],
                                  isSpoiler: posts[index]['isSpoiler'],
                                  isOC: posts[index]['isOC'],
                                  isCrosspost: posts[index]['isCrosspost'],
                                  awards: posts[index]['awards'],
                                  media: '',
                                  link: '',
                                  isDraft: posts[index]['isDraft'],
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
