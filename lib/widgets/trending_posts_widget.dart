import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/t_post.dart';
import '../controller/search_cubit/search_cubit.dart';
import 'trending_post_item_widget.dart';

class TrendingPostsWidget extends StatelessWidget {
  const TrendingPostsWidget({
    super.key,
    required this.posts,
  });

  final List<TPost> posts;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SearchCubit>().changeCurrentPage(1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            const Text(
              'Trending Today',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return TrendingPostItemWidget(post: posts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
