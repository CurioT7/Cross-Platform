import 'package:curio/Views/Search/searchScreen.dart';
import 'package:flutter/foundation.dart';
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

import 'Search/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  //final MockApiService _apiService = MockApiService(); // Use the mock API service
  final ApiService _apiService = ApiService(); // Use the real API service
  final ScrollController _scrollController = ScrollController();
  List<Post> _posts = [];
  bool _isLoading = true;
  String dropdownValue = 'Home';

  @override
  void initState() {
    super.initState();
    _fetchBestPosts(dropdownValue);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchBestPosts(dropdownValue);
      }
    });
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('token');
    return action;
  }

  Future<void> _fetchBestPosts(String category) async {
    try {
      List<Post> posts;
      if (category == 'Home') {
        posts = await _apiService.getBestPosts();
      } else if (category == 'Popular') {
        posts = await _apiService.getPopularPosts();
      } else if (category == 'Discovery') {
        posts = await _apiService.getDiscoveryPosts();
      } else if (category == 'Trending') {
        posts = await _apiService.getTrendingPosts();
      } else {
        posts = [];
      }
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebar(),
      endDrawer: SidebarAfterLogIn(),
      bottomNavigationBar: const HomeNavigationBar(),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),

              );
            },
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.redditstatic.com/avatars/avatar_default_13_46D160.png'),
              ),
            ),
          ),
        ],
        title: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
              _isLoading = true;
            });
            _fetchBestPosts(newValue!);
          },
          items: <String>['Home', 'Popular', 'Discovery', 'Trending']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Icon(value == 'Home'
                        ? Icons.home
                        : value == 'Popular'
                            ? Icons.stars_rounded
                            : value == 'Discovery'
                                ? Icons.explore
                                : Icons.trending_up), 
                    const SizedBox(width: 8),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _fetchBestPosts(dropdownValue),
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
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.remove('token');
          } catch (e) {
            print(e);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
