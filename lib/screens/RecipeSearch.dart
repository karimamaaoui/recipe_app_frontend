import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_project/screens/RecipeDetailsPage.dart';
import 'package:receipe_project/screens/RecipeService.dart';

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({super.key});

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}


class _RecipeSearchState extends State<RecipeSearch> {

  List<dynamic> recipes = [];
  final TextEditingController _keywordController = TextEditingController();

  List<String> selectedIngredients = [];
  final List<String> ingredients = [
    'Tomato', 'Vanilla', 'Cucumber', 'Onion', 'Carrot', 'Chocolate'
  ];
  String? recipeImageUrl;

  // Variables pour la pagination
  int page = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  Map<String, String> ingredientImages = {};

  Map<String, String> recipeImages = {};

  Future<void> fetchRecipeImage(String query) async {
    final imageUrl = await RecipeService.fetchRecipeImage(query);
    setState(() {
      recipeImages[query] = imageUrl ?? '';
    });
  }

  // Fetching the image for a given ingredient
  Future<void> fetchIngredientImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {
          'Authorization': 'ZVCm4CAeFdTw2z58Mpu4cVZqHEOC8EhNPeAGVW3KG5yGETH5R4DYX13I',
        },
      );
    //  print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
       // print("data $data");
        //print( data['photos'] );
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          String imageUrl = data['photos'][0]['src']['medium'];
          setState(() {
            ingredientImages[query] = imageUrl;
          });
          //print("ingredientImages $ingredientImages");

        } else {
          setState(() {
            ingredientImages[query] = '';
          });
        }
      } else {
        throw Exception('Failed to load image for $query');
      }
    } catch (e) {
      setState(() {
        ingredientImages[query] = '';
      });
    }
  }


 Future<void> fetchRecipes({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        page = 1;
        hasMore = true;
        recipes.clear();
      });
    } else {
      setState(() {
        isLoadingMore = true;
      });
    }

    final keyword = _keywordController.text.trim();
    final combinedQuery = [
      if (keyword.isNotEmpty) keyword,
      ...selectedIngredients
    ].join(', ');

    if (combinedQuery.isEmpty || !hasMore) return;

    // Fetching recipes from RecipeService
    try {
      final fetchedRecipes = await RecipeService.fetchRecipes(
        keyword: keyword,
        selectedIngredients: selectedIngredients,
        page: page,
        count: 10,
      );

      setState(() {
        if (fetchedRecipes.isNotEmpty) {
          recipes.addAll(fetchedRecipes);
          for (var recipe in recipes) {
            fetchRecipeImage(recipe['title']);
          }
          page++;
          hasMore = fetchedRecipes.length == 10;
        } else {
          hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

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
                hintText: 'Pasta, Cake, Couscous ...',
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
              'Select ingredients:',
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
                  final isSelected = selectedIngredients.contains(ingredient);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIngredients.remove(ingredient);
                        } else {
                          selectedIngredients.add(ingredient);
                        }
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isSelected ? Colors.orangeAccent : Colors.white,
                      elevation: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(imageUrl,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported))
                              : const Icon(Icons.image, size: 40),
                          const SizedBox(width: 8),
                          Text(
                            ingredient,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              child: ListView.builder(
                itemCount: recipes.length + 1,
                itemBuilder: (context, index) {
                  if (index == recipes.length) {
                    return hasMore
                        ? SizedBox(
                      width: 100,
                      child: IconButton(
                        onPressed: () => fetchRecipes(loadMore: true),
                        icon: isLoadingMore
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.keyboard_arrow_down, size: 30),
                      ),
                    )
                        : const SizedBox();
                  }
                  final recipe = recipes[index];
                  final recipeImageUrl = recipeImages[recipe['title']] ?? '';
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: recipeImageUrl.isNotEmpty
                            ? Image.network(
                          recipeImageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 50,
                          ),
                        )
                            : Icon(
                          Icons.fastfood,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      ),
                      title: Text(recipe['title']),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(recipe: recipe),
                          ),
                        );
                      },
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