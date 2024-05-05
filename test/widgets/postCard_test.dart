import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:curio/Models/post_header.dart';
import 'package:curio/widgets/postCard.dart';

void main() {
  testWidgets('postCard displays post details correctly', (tester) async {
    mockNetworkImagesFor(() async {
      // Create a sample post
      final post = Post(
        id: '1',
        linkedSubreddit: 'flutter',
        authorName: 'JohnDoe',
        createdAt: DateTime.now(),
        title: 'Sample Post',
        content: 'This is a sample post',
        upvotes: 10,
        downvotes: 5,
        isNSFW: false,
        isSpoiler: false,
        isOC: false,
        isCrosspost: false,
        media: '',
        comments: [],
        shares: 0,
        awards: 0,
        link: '',
        isDraft: false,
        views: 66,
      );

      // Build the PostCard widget
      await tester.pumpWidget(MaterialApp(home: PostCard(post: post)));

      // Verify that the post details are displayed correctly
      expect(find.text('r/flutter'), findsOneWidget);
      expect(find.text('u/JohnDoe'), findsOneWidget);
      expect(find.text('Sample Post'), findsOneWidget);
      expect(find.text('This is a sample post'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.comment), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });
  });
}