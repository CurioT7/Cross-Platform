import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:curio/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/comment/commentCard.dart';
import 'package:curio/widgets/savedCommentCard.dart';

class PostsCommentsExample extends StatelessWidget {
  const PostsCommentsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const TabBarExample(),
    );
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
    with WidgetsBindingObserver {
  late Future<Map<String, dynamic>> savedData = Future.value({});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadSavedData(); // Call the method here
    // replace 'your_token_here' with your actual token
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      loadSavedData();
    }
  }
  Future<void> loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final data = await ApiService().fetchSavedPostsAndComments(token!);
    setState(() {
      savedData = Future.value(data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: HomeNavigationBar(),
        appBar: AppBar(
          title: const Text('Saved'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Posts',
              ),
              Tab(
                text: 'Comments',
              ),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: savedData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Icon(Icons.local_hospital));
              }
              return TabBarView(
                children: <Widget>[
                  // First tab: Posts
                  RefreshIndicator(
                    onRefresh: loadSavedData,
                    child: snapshot.data!['savedPosts'].isEmpty
                        ? const Center(child: Text('No saved posts'))
                        : ListView.builder(
                      itemCount: snapshot.data!['savedPosts'].length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          post: snapshot.data!['savedPosts'][index],
                        );
                      },
                    ),
                  ),
                  // Second tab: Comments
                  RefreshIndicator(
                    onRefresh: loadSavedData,
                    child: snapshot.data!['savedComments'].isEmpty
                        ? const Center(child: Text('No saved comments'))
                        : ListView.builder(
                      itemCount: snapshot.data!['savedComments'].length,
                      itemBuilder: (context, index) {
                        /**
                         *  "authorName": "Arianna.Gutkowski53",
                            "createdAt": "2023-07-10T19:06:25.448Z",
                            "upvotes": 30105,
                         */
                        String metaData = snapshot.data!['savedComments'][index].authorUsername +
                            ' - ' +
                            snapshot.data!['savedComments'][index].createdAt.toString() +
                            ' - ' +
                            snapshot.data!['savedComments'][index].upvotes.toString() +
                            ' upvotes';
                        return SavedCommentCard(
                          title: snapshot.data!['titles'][index],
                          content: snapshot.data!['savedComments'][index].content,
                          postID: snapshot.data!['savedComments'][index].linkedPost,
                          metaData: metaData,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
