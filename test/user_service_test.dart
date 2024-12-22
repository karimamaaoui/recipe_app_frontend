import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:receipe_project/screens/auth/service/UserService.dart';
import 'package:receipe_project/constants/constant.dart';

@GenerateMocks([http.Client])
import 'user_service_test.mocks.dart';

void main() {
  late MockClient mockClient;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockClient = MockClient();
    SharedPreferences.setMockInitialValues({});
    UserService.client = mockClient;
  });

  group('UserService login tests', () {
    testWidgets('login should return false when credentials are empty', (WidgetTester tester) async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid credentials"}', 401));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Act & Assert
                UserService.login(context, '', '').then((result) {
                  expect(result, false);
                });
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that dialog is shown
      expect(find.text('Please enter both email and password.'), findsOneWidget);

      // Tap OK button to dismiss dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });

    testWidgets('login should return true when credentials are valid', (WidgetTester tester) async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"token": "fake_token"}',
        200,
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Act & Assert
                UserService.login(context, 'test@email.com', 'password').then((result) {
                  expect(result, true);
                });
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that success dialog is shown
      expect(find.text('Login successful.'), findsOneWidget);

      // Tap OK button to dismiss dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });

    testWidgets('login should return false when server returns error', (WidgetTester tester) async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"error": "Invalid credentials"}',
        401,
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Act & Assert
                UserService.login(context, 'test@email.com', 'wrong_password').then((result) {
                  expect(result, false);
                });
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that error dialog is shown
      expect(find.text('Invalid email or password.'), findsOneWidget);

      // Tap OK button to dismiss dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });
  });
}