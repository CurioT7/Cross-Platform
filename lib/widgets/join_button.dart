import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/services/logicAPI.dart'; 

class JoinButton extends StatefulWidget {
  final bool isUserMemberOfItemSubreddit;
  final String communityName;
  final logicAPI apiLogic = logicAPI();

  JoinButton({
    required this.isUserMemberOfItemSubreddit,
    required this.communityName,
  });

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  bool _buttonPressed = false;

  void _handlePress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    if (!widget.isUserMemberOfItemSubreddit) {
      try {
        await widget.apiLogic.joinCommunity(token, widget.communityName);
        setState(() {
          _buttonPressed = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'You have successfully joined the community: ${widget.communityName}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        });
      } catch (e) {
        print('Error joining community: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the user is a member of the subreddit, don't show the join button
    if (widget.isUserMemberOfItemSubreddit) {
      return SizedBox.shrink();
    }

    return Container(
      width: 40,
      height: 30,
      child: _buttonPressed
          ? Icon(Icons.check, color: Color.fromARGB(255, 3, 94, 252))
          : ElevatedButton(
              onPressed: _handlePress,
              child: Text(
                'Join',
                style: TextStyle(fontSize: 11),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 3, 94, 252)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              ),
            ),
    );
  }
}