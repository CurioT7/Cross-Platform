import 'package:curio/controller/account_cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/about_section.dart';
import '../widgets/comments_tab.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_posts_tab.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    super.key,
    this.isUser = false,
    this.userName,
    this.userDetails,
    this.days,
  });

  final bool isUser;
  final String? userName;
  final Map? userDetails;
  final int? days;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  static const List<String> _sections = ['Posts', 'Comments', 'About'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit()..getUserInfo(),
      child: Scaffold(
        body: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state is GetAccountInfoLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetAccountInfoErrorState) {
              return DefaultTabController(
                length: _sections.length,
                child: CustomScrollView(
                  slivers: [
                    ProfileAppBar(
                      isUser: widget.isUser,
                      userDetails: widget.userDetails,
                      userName: widget.userName,
                      days: widget.days,
                    ),
                    SliverToBoxAdapter(
                      child: TabBar(
                        indicatorColor: Colors.blue,
                        labelColor: Colors.blue,
                        tabs: _sections.map(
                              (section) {
                            return Tab(
                              text: section,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    SliverFillRemaining(
                      child: TabBarView(
                        children: [
                          ProfilePostsTab(
                            userName: widget.userName ?? 'testing',
                          ),
                          CommentsTab(
                            userName: widget.userName ?? 'testing',
                          ),
                          AboutSection(
                            postKarmaNumber:
                            widget.userDetails?['postKarma'] ?? '0',
                            commentKarmaNumber:
                            widget.userDetails?['commentKarma'] ?? '0',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
