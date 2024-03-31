import 'package:curio/controller/account_cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/profile_app_bar.dart';
import '../widgets/profile_posts_tab.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

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
            } else if (state is GetAccountInfoSuccessState) {
              return DefaultTabController(
                length: _sections.length,
                child: CustomScrollView(
                  slivers: [
                    const ProfileAppBar(),
                    SliverToBoxAdapter(
                      child: TabBar(
                        tabs: _sections.map(
                          (section) {
                            return Tab(
                              text: section,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const SliverFillRemaining(
                      child: TabBarView(
                        children: [
                          ProfilePostsTab(),
                          Center(
                            child: Text('Tab 2'), // Removed 'Posts'
                          ),
                          Center(
                            child: Text('Tab 3'), // Removed 'Posts'
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
