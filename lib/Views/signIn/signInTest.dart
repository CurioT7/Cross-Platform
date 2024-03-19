import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curio/Views/signIn/sign_in_page.dart';
import 'package:curio/Views/signUp/signup.dart';

void main() {
  testWidgets('Sign In Page - UI Test', (WidgetTester tester) async {
    // Build the SignInPage widget.
    await tester.pumpWidget(MaterialApp(home: SignInPage()));

    // Verify that the title is displayed correctly.
    expect(find.text('Log In to Curio'), findsOneWidget);

    // Verify that the email and password text fields are displayed.
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify that the "Continue" button is displayed.
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Sign In Page - Button Test', (WidgetTester tester) async {
    // Build the SignInPage widget.
    await tester.pumpWidget(MaterialApp(home: SignInPage()));

    // Tap the "Continue" button.
    await tester.tap(find.text('Continue'));
    await tester.pump();

    // Verify that the email and password fields are validated.
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('Sign In Page - Navigation Test', (WidgetTester tester) async {
    // Build the SignInPage widget.
    await tester.pumpWidget(MaterialApp(home: SignInPage()));

    // Tap the "Sign Up" button.
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify that the SignUpPage is pushed onto the navigation stack.
    expect(find.byType(SignupPage), findsOneWidget);

    // Go back to the SignInPage.
    await tester.pageBack();

    // Verify that the SignInPage is displayed again.
    expect(find.byType(SignInPage), findsOneWidget);
  });
}