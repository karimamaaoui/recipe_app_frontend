import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  Map<String, String> ingredientImages = {};
  String? recipeImageUrl;

  @override
  void initState() {
    super.initState();
    fetchRecipeImage(widget.recipe['title']);
    // Fetch images for all ingredients
    final ingredients = (widget.recipe['ingredients'] as String).split(", ");
    for (var ingredient in ingredients) {
      fetchIngredientImage(ingredient);
    }
  }


  // Fetch image for the recipe title
  Future<void> fetchRecipeImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {
          'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          String imageUrl = data['photos'][0]['src']['medium'];
          setState(() {
            recipeImageUrl = imageUrl;
          });
        } else {
          setState(() {
            recipeImageUrl = ''; // No image found
          });
        }
      } else {
        throw Exception('Failed to load recipe image');
      }
    } catch (e) {
      setState(() {
        recipeImageUrl = ''; // Error case
      });
    }
  }
  Future<void> fetchIngredientImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {
          'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          String imageUrl = data['photos'][0]['src']['medium'];
          setState(() {
            ingredientImages[query] = imageUrl;
          });
        } else {
          setState(() {
            ingredientImages[query] = ''; // No image found
          });
        }
      } else {
        throw Exception('Failed to load image for $query');
      }
    } catch (e) {
      setState(() {
        ingredientImages[query] = ''; // Error case
      });
    }
  }

  // Clean up the directions to remove unwanted characters
  List<String> cleanDirections(dynamic directions) {
    if (directions is String) {
      // If it's a single string, split it by newline characters
      return directions
          .replaceAll('[', '') // Remove '['
          .replaceAll(']', '') // Remove ']'
          .replaceAll('"', '') // Remove quotes
          .split(", "); // Split by commas
    } else if (directions is List<dynamic>) {
      // If it's already a list, convert it to a list of strings
      return directions.cast<String>();
    }
    // Return an empty list if it's neither
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Clean directions before displaying
    final List<String> directions = cleanDirections(widget.recipe['directions']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image if available
              if (recipeImageUrl != null && recipeImageUrl!.isNotEmpty)
                Image.network(
                  recipeImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),


              const SizedBox(height: 16),


              const Text(
                'Ingredients:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),

              // Grid of ingredients
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (widget.recipe['ingredients'] as String)
                    .split(", ")
                    .length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final List<String> ingredients =
                  (widget.recipe['ingredients'] as String).split(", ");
                  final ingredient = ingredients[index];
                  final imageUrl = ingredientImages[ingredient];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: imageUrl != null && imageUrl.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: imageUrl == null || imageUrl.isEmpty
                            ? const Icon(Icons.food_bank,
                            size: 40, color: Colors.green)
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ingredient,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // Directions section
              const Text(
                'Directions:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // List of directions
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: directions.length,
                itemBuilder: (context, index) {
                  final direction = directions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}. $direction',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
