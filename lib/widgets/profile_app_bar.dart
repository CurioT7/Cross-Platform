import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:curio/services/ahmed_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/report/report_cubit.dart';
import 'block_dialog.dart';
import 'report_user_or_post_bottom_sheet.dart';
import 'package:http/http.dart' as http;

class ProfileAppBar extends StatefulWidget {
  const ProfileAppBar({
    super.key,
    this.isUser = false,
    this.userDetails,
    this.userName,
    this.days,
  });

  final bool isUser;
  final String? userName;
  final Map? userDetails;
  final int? days;

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  bool _isFollowing = false;
  void _showReportProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return BlocProvider(
          create: (context) => ReportCubit(),
          child: const ReportUserOrPostBottomSheet(isUser: true),
        );
      },
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlockDialog(userName: widget.userName);
      },
    );
  }

  void getFriends() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/getfriends/followings'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          log(responseBody['friendsArray'].toString());
          for (var user in responseBody['friendsArray']) {
            if (user['username'] == widget.userName) {
              setState(() {
                _isFollowing = true;
              });
            }
          }
        }
      } else {
        log(response.body.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: const Color(0xff0077D6),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
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
          visible: widget.isUser,
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
      expandedHeight: widget.isUser
          ? MediaQuery.sizeOf(context).height * 0.39
          : MediaQuery.sizeOf(context).height * 0.5,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
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
              CircleAvatar(
                radius: 50.0,
                backgroundImage: widget.userDetails == null
                    ? const AssetImage('lib/assets/images/avatar.jpeg')
                    : NetworkImage(widget.userDetails!['profilePicture'])
                        as ImageProvider,
              ),
              const SizedBox(height: 12.0),
              Visibility(
                visible: !widget.isUser,
                replacement: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!_isFollowing) {
                          await ApiService().followUser(widget.userName!).then(
                            (value) {
                              setState(() {
                                _isFollowing = true;
                              });
                              Fluttertoast.showToast(
                                msg: 'Following ${widget.userName}',
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                          ).catchError((error) {
                            setState(() {
                              _isFollowing = false;
                            });
                          });
                        } else {
                          await ApiService()
                              .unfollowUser(widget.userName!)
                              .then((value) {
                            setState(() {
                              _isFollowing = false;
                            });
                            Fluttertoast.showToast(
                              msg:
                                  'You are no longer following ${widget.userName}',
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }).catchError((error) {
                            setState(() {
                              _isFollowing = true;
                            });
                          });
                        }
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
                      child: Text(_isFollowing ? 'Following' : 'Follow'),
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
              Text(
                widget.userName ?? 'Middle_Mall8968',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'u/${widget.userName} - ${widget.userDetails?['postKarma'] ?? 0} karma - ${widget.days ?? 1} days',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              if (!widget.isUser) ...[
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
      ),
    );
  }
}
