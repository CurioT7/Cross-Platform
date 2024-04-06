import 'package:flutter/material.dart';
import 'package:curio/Views/sidebars/sideBarAfterLogIn.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:curio/Views/signIn/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:curio/Models/post.dart';
import 'package:curio/services/postService.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/views/sidebars/customSidebar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  // final MockApiService _apiService = MockApiService(); // Use the mock API service
  final ApiService _apiService = ApiService(); // Use the real API service
  final ScrollController _scrollController = ScrollController();
  List<Post> _posts = [];
  bool _isLoading = true;
  String dropdownValue = 'Home';

  @override
  void initState() {
    super.initState();
    _fetchBestPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchBestPosts();
      }
    });
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('token');
    return action;
  }

  Future<void> _fetchBestPosts() async {
    try {
      List<Post> posts = await _apiService.getBestPosts();
      setState(() {
        _posts.addAll(posts);
        _isLoading = false;
      });
    } catch (e) {
      // Handle the exception
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebar(),
      endDrawer: sidebarAfterLogIn(),
      bottomNavigationBar: homeNavigationBar(),
      appBar: AppBar(

        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement your search functionality here
            },
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=13'),
              ),
            ),
          ),
        ],
        title: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['Home', 'Popular', 'Discovery']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(value == 'Home' ? Icons.home : value == 'Popular' ? Icons.trending_up : Icons.explore),
                  SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchBestPosts,
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: _posts[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
          } catch (e) {
            print(e);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ),
          );
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}