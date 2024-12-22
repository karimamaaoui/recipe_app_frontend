import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:receipe_project/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:receipe_project/main.dart' as app;
import 'package:receipe_project/screens/home/HomeScreen.dart';
import 'package:receipe_project/OnboardingScreen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Initialization Test', () {
    testWidgets('Should show OnboardingScreen when not authenticated',
            (WidgetTester tester) async {
          // Configurer SharedPreferences sans token
          SharedPreferences.setMockInitialValues({});

          // Démarrer l'application
          await tester.pumpWidget(
              const app.MyApp(isAuthenticated: false)
          );
          await tester.pumpAndSettle();

          // Vérifier qu'on est sur l'écran d'onboarding
          expect(find.byType(OnboardingScreen), findsOneWidget);
          expect(find.byType(HomeScreen), findsNothing);
        });

    testWidgets('Should show HomeScreen when authenticated',
            (WidgetTester tester) async {
          // Configurer SharedPreferences avec un token
          SharedPreferences.setMockInitialValues({
            'token': 'fake_token'
          });

          // Démarrer l'application
          await tester.pumpWidget(
              const app.MyApp(isAuthenticated: true)
          );
          await tester.pumpAndSettle();

          // Vérifier qu'on est sur l'écran d'accueil
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(OnboardingScreen), findsNothing);
        });

    testWidgets('Should apply theme correctly', (WidgetTester tester) async {
      // Démarrer l'application
      await tester.pumpWidget(
          const app.MyApp(isAuthenticated: false)
      );
      await tester.pumpAndSettle();

      // Récupérer le thème
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      final ThemeData theme = materialApp.theme!;

      // Vérifier les configurations du thème
      expect(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          primaryColor);
      expect(theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
          Colors.white);
      expect(theme.inputDecorationTheme.contentPadding,
          const EdgeInsets.all(defaultPadding));
    });
  });

  group('Authentication Flow Test', () {
    testWidgets('Should handle token changes', (WidgetTester tester) async {
      // Démarrer sans authentification
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
          const app.MyApp(isAuthenticated: false)
      );
      await tester.pumpAndSettle();

      // Vérifier l'écran initial
      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Simuler une connexion en ajoutant un token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'new_token');

      // Redémarrer l'application
      await tester.pumpWidget(
          const app.MyApp(isAuthenticated: true)
      );
      await tester.pumpAndSettle();

      // Vérifier la redirection
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}