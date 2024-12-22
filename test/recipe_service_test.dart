/*import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_project/screens/RecipeService.dart';
import 'package:receipe_project/constants/constant.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([http.Client])
import 'recipe_service_test.mocks.dart';
import 'user_service_test.mocks.dart';

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    RecipeService.client = mockClient; // Assurez-vous d'ajouter un client statique dans RecipeService
  });

  group('RecipeService tests', () {
    test('getLatestRecipes returns list of recipes on success', () async {
      // Préparer les données de test
      final mockRecipes = [
        {
          'id': 1,
          'title': 'Pasta Carbonara',
          'description': 'Classic Italian pasta'
        },
        {
          'id': 2,
          'title': 'Caesar Salad',
          'description': 'Fresh salad with caesar dressing'
        }
      ];

      // Configurer le mock
      when(mockClient.get(
        Uri.parse('$baseUrl/api/recipes/latest'),
      )).thenAnswer((_) async =>
          http.Response(json.encode(mockRecipes), 200)
      );

      // Exécuter la méthode
      final result = await RecipeService.getLatestRecipes();

      // Vérifier les résultats
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result[0]['title'], 'Pasta Carbonara');
      expect(result[1]['title'], 'Caesar Salad');
    });

    test('getLatestRecipes throws exception on error', () async {
      // Configurer le mock pour simuler une erreur
      when(mockClient.get(
        Uri.parse('$baseUrl/api/recipes/latest'),
      )).thenAnswer((_) async =>
          http.Response('Server error', 500)
      );

      // Vérifier que l'exception est levée
      expect(
            () => RecipeService.getLatestRecipes(),
        throwsException,
      );
    });

    test('getLatestRecipes handles network error', () async {
      // Configurer le mock pour simuler une erreur réseau
      when(mockClient.get(
        Uri.parse('$baseUrl/api/recipes/latest'),
      )).thenThrow(Exception('Network error'));

      // Vérifier que l'exception est levée
      expect(
            () => RecipeService.getLatestRecipes(),
        throwsException,
      );
    });
  });
}*/