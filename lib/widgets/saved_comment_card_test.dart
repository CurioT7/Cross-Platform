import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:curio/widgets/savedCommentCard.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('SavedCommentCard widget test', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();

    // Build the SavedCommentCard widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SavedCommentCard(
          postID: 'testPostID',
          title: 'testTitle',
          content: 'testContent',
          metaData: 'testMetaData',
        ),
      ),
      navigatorObservers: [mockObserver],
    ));

    // Verify that the title is in the widget tree
    expect(find.text('testTitle'), findsOneWidget);

    // Verify that the metadata is in the widget tree
    expect(find.text('testMetaData'), findsOneWidget);

    // Verify that the content is in the widget tree
    expect(find.text('testContent'), findsOneWidget);

    // Tap the card and trigger a frame
    await tester.tap(find.byType(SavedCommentCard));
    await tester.pumpAndSettle();
  });
}

