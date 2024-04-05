import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:curio/Models/post.dart';
class MockApiService {
  Future<http.Response> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // Check the credentials (you can define your own logic here)
    if (email == 'test@example.com' && password == '123') {
      // Simulate a successful response with a mock token
      var response = {
        'token': 'mock-token',
        'user': {
          'id': '1',
          'name': 'John Doe',
          'email': 'test@example.com',
        },
      };
      return http.Response(jsonEncode(response), 200);
    } else {
      // Simulate an error response
      var response = {
        'error': 'Invalid credentials',
      };
      return http.Response(jsonEncode(response), 400);
    }
  }

  Future<List<Post>> getBestPosts() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Return a list of fake posts
    return List.generate(100, (index) => Post(
      id: 'post_$index',
      title: 'Post Title $index',
      content: 'Post Content $index',
      authorName: 'Author $index',
      views: index * 10,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      upvotes: index * 100,
      downvotes: index * 10,
      linkedSubreddit: 'subreddit_$index',
      comments: List.generate(index, (i) => 'Comment $i'), // Generate some fake comments
      shares: index * 5,
      isNSFW: false,
      isSpoiler: false,
      isOC: false,
      isCrosspost: false,
      awards: index * 3,
      media: 'https://via.placeholder.com/150',
      link: 'https://example.com/post_$index',
      isDraft: false,
    ));
  }

  Future<Post> getRandomPost(String subreddit) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Return a fake post
    return Post(
      id: 'random_post',
      title: 'Random Post',
      content: 'This is a random post from r/$subreddit',
      authorName: 'Random Author',
      views: 100,
      createdAt: DateTime.now(),
      upvotes: 1000,
      downvotes: 100,
      linkedSubreddit: subreddit,
      comments: List.generate(10, (i) => 'Comment $i'), // Generate some fake comments
      shares: 50,
      isNSFW: false,
      isSpoiler: false,
      isOC: false,
      isCrosspost: false,
      awards: 10,
      media: 'https://via.placeholder.com/150',
      link: 'https://example.com/random_post',
      isDraft: false,
    );
  }
}