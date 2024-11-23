import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_project/constants.dart';
import 'package:receipe_project/screens/ServiceFavorite.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  Map<String, String> ingredientImages = {};
  String? recipeImageUrl;
  bool isFavorite = false;
  final ServiceFavorite serviceFavorite = ServiceFavorite();


  @override
  void initState() {
    super.initState();
    checkIfFavorite();
    fetchRecipeImage(widget.recipe['title']);
    final ingredients = (widget.recipe['ingredients'] as String).split(", ");
    for (var ingredient in ingredients) {
      fetchIngredientImage(ingredient);
    }
  }

  // Fetch recipe image from Pexels API
  Future<void> fetchRecipeImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {
          'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I', },
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

  // Fetch ingredient image from Pexels API
  Future<void> fetchIngredientImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {
          'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I',  },
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

  // Clean up the directions text format
  List<String> cleanDirections(dynamic directions) {
    if (directions is String) {
      return directions
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(", ");
    } else if (directions is List<dynamic>) {
      return directions.cast<String>();
    }
    return [];
  }

  // Check if the recipe is already a favorite
  Future<void> checkIfFavorite() async {
    List<Map<String, dynamic>> favorites = await serviceFavorite.getFavorites();
    isFavorite = favorites.any((recipe) => recipe['title'] == widget.recipe['title']);
    setState(() {});
  }

  // Toggle favorite state
  Future<void> toggleFavorite() async {
    if (isFavorite) {
      await serviceFavorite.removeFavorite(widget.recipe);
    } else {
      await serviceFavorite.addFavorite(widget.recipe);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  // Share the recipe link
  void _shareContent() {
    Share.share(widget.recipe['link']);
  }



  @override
  Widget build(BuildContext context) {
    final List<String> directions = cleanDirections(widget.recipe['directions']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['title']),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                (widget.recipe['ingredients'] as String).split(", ").length,
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
              const Text(
                'Directions:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              const Text(
                'Source:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  if (await canLaunch(widget.recipe['link'])) {
                    await launch(widget.recipe['link']);
                  } else {
                    throw 'Could not launch ${widget.recipe['link']}';
                  }
                },
                child: Text(
                  widget.recipe['link'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _shareContent,
                child: const Text('Share Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
