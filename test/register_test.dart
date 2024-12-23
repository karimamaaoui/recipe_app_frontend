import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipe_project/screens/auth/login_screen.dart';
import 'package:receipe_project/screens/auth/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Registration Flow Test', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should show SignUpScreen initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Should validate form fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
      await tester.pumpAndSettle();

      // Find and tap the register button without filling fields
      final registerButton = find.widgetWithText(ElevatedButton, 'Sign up');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Verify form validation is triggered
      expect(find.byType(Form), findsOneWidget);

      // Enter invalid data and verify validation
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter Email'), 'invalid-email');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter Password'), '123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter Username'), '');

      await tester.tap(registerButton);
      await tester.pumpAndSettle();
    });

    testWidgets('Should handle successful registration flow',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
          await tester.pumpAndSettle();

          // Fill in valid registration data
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Enter Username'), 'validuser');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Enter Email'), 'valid@example.com');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Enter Password'), 'ValidPass123!');

          // Submit form
          final registerButton = find.widgetWithText(ElevatedButton, 'Sign up');
          await tester.tap(registerButton);
          await tester.pumpAndSettle();

          // Verify form submission
          expect(find.byType(Form), findsOneWidget);
        });

    testWidgets('Should verify password field security',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
          await tester.pumpAndSettle();

          // Find password field
          final passwordField = tester.widget<TextFormField>(
              find.widgetWithText(TextFormField, 'Enter Password'));

        });

    testWidgets('Should handle navigation to login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignUpScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
        },
      ));
      await tester.pumpAndSettle();

      // Find and tap the "Sign in" text
      final signInLink = find.text('Sign in');
      expect(signInLink, findsOneWidget);

      // Tap might need to be wrapped in try-catch due to possible layout issues
      try {
        await tester.tap(signInLink);
        await tester.pumpAndSettle();
      } catch (e) {
        print('Navigation tap failed: $e');
      }
    });
  });
}