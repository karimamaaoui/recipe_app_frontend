import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:receipe_project/constants/constant.dart';

class RecipeService {
  static const String _pexelsApiKey = 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I';
  static const String _pexelsBaseUrl = 'https://api.pexels.com/v1/search';

  static Future<String> fetchRecipeImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_pexelsBaseUrl?query=$query'),
        headers: {'Authorization': _pexelsApiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          return data['photos'][0]['src']['medium'];
        } else {
          return ''; // No image found
        }
      } else {
        throw Exception('Failed to load recipe image');
      }
    } catch (e) {
      print('Error fetching recipe image: $e');
      return ''; // Error case
    }
  }


 static Future<List<Map<String, dynamic>>> getLatestRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/recipes/latest'));

      if (response.statusCode == 200) {
        // Décoder la réponse JSON
       // print(response.body);
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch latest recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
