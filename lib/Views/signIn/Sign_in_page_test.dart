import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curio/Views/signIn/sign_in_page.dart';

void main() {
  group('SignInPage', () {
    testWidgets('renders sign in form', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInPage()));

      expect(find.text('Reddit Clone Sign In'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('validates form and signs in', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInPage()));

      // Enter email and password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password');

      // Tap the sign in button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that sign in was successful
      expect(find.text('Signed in with token:'), findsOneWidget);
    });

    testWidgets('validates form and shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInPage()));

      // Tap the sign in button without entering email and password
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that error message is displayed
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });
}