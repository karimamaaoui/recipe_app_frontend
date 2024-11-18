import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({super.key});

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  List<dynamic> recipes = [];
  final TextEditingController _keywordController = TextEditingController();
  String? selectedIngredient;
  final List<String> ingredients = [
    'Tomato', 'Vanilla', 'Cucumber', 'Onion', 'Carrot','Chocolate'
  ];

  Map<String, String> ingredientImages = {};

  // Fetching the image for a given ingredient
  Future<void> fetchIngredientImage(String query) async {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$query'),
      headers: {
        'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I'
      },
    );
    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      print(data);
      String imageUrl = data['photos'][0]['src']['medium'];
      setState(() {
        ingredientImages[query] = imageUrl;
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> fetchRecipes() async {
    final keyword = selectedIngredient ?? _keywordController.text;
    if (keyword.isEmpty) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/search?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      setState(() {
        recipes = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch images for all ingredients
    for (var ingredient in ingredients) {
      fetchIngredientImage(ingredient);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                labelText: 'Search by keyword',
                hintText: 'e.g., Pasta, Cake...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select an ingredient:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  final imageUrl = ingredientImages[ingredient] ?? '';
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIngredient = ingredient;
                        _keywordController.clear();
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: selectedIngredient == ingredient
                          ? Colors.orangeAccent
                          : Colors.white,
                      elevation: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(imageUrl, height: 40, width: 40, fit: BoxFit.cover)
                              : Container(), // Display image if available
                          SizedBox(width: 8),
                          Text(
                            ingredient,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchRecipes,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recipes.isEmpty
                  ? const Center(child: Text('No recipes found'))
                  : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  var recipe = recipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 8),
                    child: ListTile(
                      title: Text(recipe['title']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
