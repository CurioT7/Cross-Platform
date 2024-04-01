import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final Function onTap;

  const CommunityCard(
      {super.key, required this.community, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        children: [
          Icon(
            community.image,
            size: 40,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${community.followersCount} ${community.followersText} • ${community.isFollowingText}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Community {
  // some dummy data
  final String name;
  final IconData image;
  final int followers;
  bool isFollowing;
  // constructor
  Community({
    required this.name,
    required this.image,
    required this.followers,
    required this.isFollowing,
  });
  // get info
  String get followersCount => followers.toString();
  String get followersText => followers == 1 ? 'Follower' : 'Followers';
  String get isFollowingText => isFollowing ? 'Following' : 'Follow';

  static List<Community> getCommunities(List<dynamic> json) {
    return json
        .map((community) => Community(
              name: community['name'],
              image: community['image'],
              followers: community['followers'],
              isFollowing: community['isFollowing'],
            ))
        .toList();
  }
}
