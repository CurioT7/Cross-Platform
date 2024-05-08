import 'package:flutter/material.dart';

import '../Models/t_post.dart';

class TrendingPostItemWidget extends StatelessWidget {
  const TrendingPostItemWidget({
    super.key,
    required this.post,
  });

  final TPost post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.title ?? 'Error',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  post.content ?? 'Error',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // style: const TextStyle(
                  //   fontSize: 18.0,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),
              ],
            ),
          ),
          Image.asset('lib/assets/images/Curio.png'),
        ],
      ),
    );
  }
}
