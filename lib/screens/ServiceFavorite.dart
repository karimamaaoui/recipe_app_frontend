import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ServiceFavorite {
  static const String _favoritesKey = 'favorites';

  // Add a favorite recipe
  Future<void> addFavorite(Map<String, dynamic> recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    String recipeJson = recipeToJson(recipe);
    favorites.add(recipeJson);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Remove a favorite recipe
  Future<void> removeFavorite(Map<String, dynamic> recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    String recipeJson = recipeToJson(recipe);
    favorites.remove(recipeJson);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Get the list of favorite recipes
  Future<List<Map<String, dynamic>>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((e) => jsonToRecipe(e)).toList();
  }

  String recipeToJson(Map<String, dynamic> recipe) {
    return jsonEncode(recipe);
  }

  Map<String, dynamic> jsonToRecipe(String json) {
    return jsonDecode(json);
  }
}
