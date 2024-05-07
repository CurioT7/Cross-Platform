
import 'package:flutter/material.dart';
import 'package:curio/widgets/searchCommentCard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:curio/models/comment.dart';
import 'package:curio/services/api_service.dart';

class MockApiService extends Mock implements ApiService {
  fetchPostComments(any) {}
}

void main() {
  testWidgets('SearchCommentCard widget test', (WidgetTester tester) async {
    final mockApiService = MockApiService();

    // Mock the fetchPostComments method
    when(mockApiService.fetchPostComments(any))
        .thenAnswer((_) async => <Comment>[]); // Replace <Comment>[] with your expected result

    // Build the SearchCommentCard widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchCommentCard(
          postID: 'testPostID',
          communityImage: 'assets/images/loft.png',
          communityName: 'testCommunity',
          postTitle: 'testTitle',
          commentContent: 'testContent',
          postUpvotes: 10,
          commentUpvotes: 5,
          numberOfComments: 3,
          postCreatedAt: '2022-01-01',
          commentCreatedAt: '2022-01-02',
          userName: 'testUser',
          apiService: mockApiService, // Pass the mock service to your widget
        ),
      ),
    ));

    // Verify that the community name is in the widget tree
    expect(find.text('testCommunity'), findsOneWidget);

    // Verify that the post title is in the widget tree
    expect(find.text('testTitle'), findsOneWidget);

    // Verify that the comment content is in the widget tree
    expect(find.text('testContent'), findsOneWidget);

    // Verify that the 'Go to comments' button is in the widget tree
    expect(find.text('Go to comments'), findsOneWidget);

    // Tap the 'Go to comments' button and trigger a frame
    await tester.tap(find.text('Go to comments'));
    await tester.pump();

    // Add more tests as needed to cover all paths in your widget
  });
}