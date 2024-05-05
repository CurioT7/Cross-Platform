// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:curio/Models/post_header.dart';

// class MockApiService {
//   Future<http.Response> signIn(String email, String password) async {
//     await Future.delayed(Duration(seconds: 1)); // Simulate network delay

//     // Check the credentials (you can define your own logic here)
//     if (email == 'test@example.com' && password == '123') {
//       // Simulate a successful response with a mock token
//       var response = {
//         'token': 'mock-token',
//         'user': {
//           'id': '1',
//           'name': 'John Doe',
//           'email': 'test@example.com',
//         },
//       };
//       return http.Response(jsonEncode(response), 200);
//     } else {
//       // Simulate an error response
//       var response = {
//         'error': 'Invalid credentials',
//       };
//       return http.Response(jsonEncode(response), 400);
//     }
//   }

//   Future<List<Post>> getBestPosts(String token, int page) async {
//     // Call the real API
//     var response = await http.get(
//       Uri.parse('http://20.199.94.136/api/homepage/$page/best'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
    
//     // Print the response
//     print('Status code: ${response.statusCode}');
//     print('Body: ${response.body}');
    
//     // Parse the response
//     var data = jsonDecode(response.body);
    
//     // Check if the response is a map and contains the 'posts' field
//     if (data is Map && data.containsKey('posts')) {
//       // Extract the 'posts' field
//       var posts = data['posts'];
      
//       // Check if 'posts' is a list
//       if (posts is List) {
//         // Create a list of Posts from the data
//         try {
//           return posts.map((item) => Post.fromJson(item['post'], {})).toList();
//         } catch (e) {
//           print('Error parsing Post: $e');
//           print('Data: $data');
//           throw e;
//         }
//       } else {
//         print('Unexpected posts data: $posts');
//         throw Exception('Unexpected posts data: $posts');
//       }
//     } else {
//       print('Unexpected response: $data');
//       throw Exception('Unexpected response: $data');
//     }
//   }

//   Future<Post> getRandomPost(String subreddit) async {
//     // Simulate network delay
//     await Future.delayed(Duration(seconds: 1));

//     // Return a fake post
//     return Post(
//       id: 'random_post',
//       title: 'Random Post',
//       content: 'This is a random post from r/$subreddit',
//       authorName: 'Random Author',
//       views: 100,
//       createdAt: DateTime.now(),
//       upvotes: 1000,
//       downvotes: 100,
//       linkedSubreddit: subreddit,
//       comments: List.generate(10, (i) => 'Comment $i'), // Generate some fake comments
//       shares: 50,
//       isNSFW: false,
//       isSpoiler: false,
//       isOC: false,
//       isCrosspost: false,
//       awards: 10,
//       media: 'https://via.placeholder.com/150',
//       link: 'https://example.com/random_post',
//       isDraft: false,
//       isLocked: false,
//       isSaved: false,
//       voteStatus: 'upvoted',
//       isUserMemberOfItemSubreddit: false,
//       subredditName: subreddit,
//     );
//   }

//   Future<List<Post>> getPopularPosts(String token, int page) async {
//     // Simulate network delay
//     await Future.delayed(Duration(seconds: 1));

//     // Check if the token is valid (you can define your own logic here)
//     if (token == 'mock-token') {
//       // Return a list of fake popular posts
//       return List.generate(50, (index) => Post(
//         id: 'popular_post_$index',
//         title: 'Popular Post $index',
//         content: 'Popular Post Content $index',
//         authorName: 'Popular Author $index',
//         views: index * 50,
//         createdAt: DateTime.now().subtract(Duration(days: index)),
//         upvotes: index * 500,
//         downvotes: index * 50,
//         linkedSubreddit: 'popular_subreddit_$index',
//         comments: List.generate(index, (i) => 'Popular Comment $i'), // Generate some fake comments
//         shares: index * 25,
//         isNSFW: false,
//         isSpoiler: false,
//         isOC: false,
//         isCrosspost: false,
//         awards: index * 5,
//         media: 'https://via.placeholder.com/150',
//         link: 'https://example.com/popular_post_$index',
//         isDraft: false,
//         isLocked: false,
//         isSaved: false,
//         voteStatus: 'upvoted',
//         isUserMemberOfItemSubreddit: false,
//         subredditName: 'popular_subreddit_$index',
//       ));
//     } else {
//       // Simulate an error response
//       throw Exception('Invalid token');
//     }
//   }

//   Future<List<Post>> getDiscoveryPosts(String token, int page) async {
//     // Simulate network delay
//     await Future.delayed(Duration(seconds: 1));

//     // Check if the token is valid (you can define your own logic here)
//     if (token == 'mock-token') {
//       // Return a list of fake discovery posts
//       return List.generate(20, (index) => Post(
//         id: 'discovery_post_$index',
//         title: 'Discovery Post $index',
//         content: 'Discovery Post Content $index',
//         authorName: 'Discovery Author $index',
//         views: index * 20,
//         createdAt: DateTime.now().subtract(Duration(days: index)),
//         upvotes: index * 200,
//         downvotes: index * 20,
//         linkedSubreddit: 'discovery_subreddit_$index',
//         comments: List.generate(index, (i) => 'Discovery Comment $i'), // Generate some fake comments
//         shares: index * 10,
//         isNSFW: false,
//         isSpoiler: false,
//         isOC: false,
//         isCrosspost: false,
//         awards: index * 2,
//         media: 'https://via.placeholder.com/150',
//         link: 'https://example.com/discovery_post_$index',
//         isDraft: false,
//         isLocked: false,
//         isSaved: false,
//         voteStatus: 'upvoted',
//         isUserMemberOfItemSubreddit: false,
//         subredditName: 'discovery_subreddit_$index',
//       ));
//     } else {
//       // Simulate an error response
//       throw Exception('Invalid token');
//     }
//   }
   
//   Future<List<Post>> getTrendingPosts(String token, int page) async {
//     // Simulate network delay
//     await Future.delayed(Duration(seconds: 1));

//     // Check if the token is valid (you can define your own logic here)
//     if (token == 'mock-token') {
//       // Return a list of fake trending posts
//       return List.generate(30, (index) => Post(
//         id: 'trending_post_$index',
//         title: 'Trending Post $index',
//         content: 'Trending Post Content $index',
//         authorName: 'Trending Author $index',
//         views: index * 30,
//         createdAt: DateTime.now().subtract(Duration(days: index)),
//         upvotes: index * 300,
//         downvotes: index * 30,
//         linkedSubreddit: 'trending_subreddit_$index',
//         comments: List.generate(index, (i) => 'Trending Comment $i'), // Generate some fake comments
//         shares: index * 15,
//         isNSFW: false,
//         isSpoiler: false,
//         isOC: false,
//         isCrosspost: false,
//         awards: index * 3,
//         media: 'https://via.placeholder.com/150',
//         link: 'https://example.com/trending_post_$index',
//         isDraft: false,
//         isLocked: false,
//         isSaved: false,
//         voteStatus: 'upvoted',
//         isUserMemberOfItemSubreddit: false,
//         subredditName: 'trending_subreddit_$index',
//       ));
//     } else {
//       // Simulate an error response
//       throw Exception('Invalid token');
//     }
//   }
// }