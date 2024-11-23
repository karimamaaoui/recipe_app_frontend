import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:receipe_project/screens/RecipeDetailsPage.dart';
import 'package:receipe_project/screens/ServiceFavorite.dart';
import 'package:http/http.dart' as http;

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ServiceFavorite serviceFavorite = ServiceFavorite();
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Load favorites and fetch the image for each favorite
  Future<void> loadFavorites() async {
    favorites = await serviceFavorite.getFavorites();

    // Fetch image for each favorite
    for (var favorite in favorites) {
      String recipeTitle = favorite['title'];
      await fetchRecipeImage(recipeTitle, favorite); // Fetch image for each favorite
    }
    setState(() {}); // Refresh UI after updating image URLs
    print("favorites $favorites");
  }

  // Fetch recipe image from Pexels API
  Future<void> fetchRecipeImage(String query, Map<String, dynamic> favorite) async {
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
            favorite['imageUrl'] = imageUrl; // Set the image URL for this specific favorite
          });
        } else {
          setState(() {
            favorite['imageUrl'] = ''; // No image found
          });
        }
      } else {
        throw Exception('Failed to load recipe image');
      }
    } catch (e) {
      setState(() {
        favorite['imageUrl'] = ''; // Error case, no image found
      });
    }
  }


  // delete a favorite
  void deleteFavorite(int index) {
    setState(() {
      favorites.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          var favorite = favorites[index];
          String title = favorite['title'] ?? '';
          String imageUrl = favorite['imageUrl'] ?? '';

          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: (imageUrl.isNotEmpty)
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 60,  // Adjust the size as needed
              height: 60, // Adjust the size as needed
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            )
                : const Icon(Icons.image, size: 40), // Default icon if no image
            title: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),  trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red), // Trash icon
            onPressed: () {
              // Confirm deletion or directly delete
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Favorite"),
                  content: Text("Are you sure you want to delete this favorite?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text("Delete"),
                      onPressed: () {
                        deleteFavorite(index); // Call delete function
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
              );
            },
          ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(recipe: favorite),
                ),
              );
            },
          );
        },
      ),
    );
  }
}