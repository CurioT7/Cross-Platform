import 'package:curio/services/ahmed_api.dart';
import 'package:flutter/material.dart';

import '../Models/user_search.dart';

class UserSearchWidget extends StatefulWidget {
  const UserSearchWidget({
    super.key,
    required this.user,
  });

  final UserSearch user;

  @override
  State<UserSearchWidget> createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: widget.user.profilePicture == null
            ? const AssetImage(
          'lib/assets/images/avatar.jpeg',
        )
            : NetworkImage(widget.user.profilePicture!) as ImageProvider,
      ),
      title: Text(widget.user.username!),
      subtitle: Text('${widget.user.karma!} karma'),
      trailing: ElevatedButton(
        onPressed: () {
          if (_isFollowing) {
            ApiService().unfollowUser(widget.user.username!);
          } else {
            ApiService().followUser(widget.user.username!);
          }
          setState(() {
            _isFollowing = !_isFollowing;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing
              ? Colors.grey.shade400
              : const Color.fromARGB(255, 0, 73, 133),
        ),
        child: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
