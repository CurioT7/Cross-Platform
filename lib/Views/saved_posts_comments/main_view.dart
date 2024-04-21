import 'package:flutter/material.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:curio/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Models/post.dart';
import 'package:curio/Models/comment.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/comment/commentCard.dart';

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
  const TabBarExample({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  late Future<Map<String, dynamic>> savedData = Future.value({});

  @override
  void initState() {
    super.initState();
    loadSavedData(); // Call the method here
    // replace 'your_token_here' with your actual token
  }

  Future<void> loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    savedData = ApiService().fetchSavedPostsAndComments(
        token!); // replace 'your_token_here' with your actual token
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: homeNavigationBar(),
        appBar: AppBar(
          title: const Text('Saved'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
              if (snapshot.data!['savedPosts'].isEmpty) {
                return TabBarView(
                  children: <Widget>[
                    const Center(
                      child: Icon(Icons.directions_car),
                    ),
                    ListView.builder(
                      itemCount: snapshot.data!['savedComments'].length,
                      itemBuilder: (context, index) {
                        return PostCard(
                            post: snapshot.data!['savedComments'][index]);
                      },
                    ),
                  ],
                );
              }
              if (snapshot.data!['savedComments'].isEmpty) {
                return TabBarView(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: snapshot.data!['savedPosts'].length,
                      itemBuilder: (context, index) {
                        return
                            // retunr a the authorUsername of the comment
                            ListTile(
                          title: Text(snapshot
                              .data!['savedPosts'][index].authorUsername),
                        );
                      },
                    ),
                    const Center(
                      child:// random icon
                      Icon(Icons.directions_car),
                    ),
                  ],
                );
              }
            }
            // Default return statement
            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }
}
