import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:receipe_project/screens/RecipeSearch.dart';
import 'package:receipe_project/screens/RecipeService.dart';
import 'package:receipe_project/screens/RecipeDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  List<Map<String, dynamic>> latestRecipes = [];
  bool isLoading = true;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    fetchLatestRecipes();
  }


  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("token $token" );
    if (token != null) {
      try {
        // Diviser le token en parties (header, payload, signature)
        final parts = token.split('.');
        if (parts.length != 3) {
          throw Exception('Token invalide');
        }

        // Décoder la partie payload du token
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final decoded = utf8.decode(base64Url.decode(normalized));

        // Convertir en Map
        final Map<String, dynamic> decodedToken = jsonDecode(decoded);
        print("Token décodé : $decodedToken");

        // Extraire le username
        setState(() {
          username = decodedToken['username'] ?? 'Utilisateur inconnu';  });
      } catch (e) {
        print("Erreur lors du décodage du token : $e");
      }
    } else {
      print("Aucun token trouvé");
    }
  }



  Future<void> fetchLatestRecipes() async {
    try {
      final recipes = await RecipeService.getLatestRecipes();

      for (var recipe in recipes) {
        final imageUrl = await RecipeService.fetchRecipeImage(recipe['title'] ?? '');
        recipe['image_url'] = imageUrl;
      }

      setState(() {
        latestRecipes = recipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome${username != null ? ', $username' : ''}',style: TextStyle(color: Colors.grey[700]),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What would you like to cook today?",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),

              _buildSectionHeader("Today's Fresh Recipes", () {}),
              SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: latestRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = latestRecipes[index];
                    return _buildRecipeCard(recipe);
                  },
                ),
              ),

              SizedBox(height: 24),

              // Recommended Section
              _buildSectionHeader("Recommended", () {}),
              SizedBox(height: 8),
              for (var recipe in latestRecipes) _buildRecommendedRecipeCard(recipe),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title, VoidCallback onSeeAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeSearch(),
              ),
            );
          },
          child: Text("See All", style: TextStyle(color: Colors.teal)),
        ),
      ],
    );
  }

  // Recipe Card for Horizontal Scroll
  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                recipe['image_url'] ?? 'https://via.placeholder.com/150',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recommended Recipe Card for Vertical List
  Widget _buildRecommendedRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: recipe),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
              child: Image.network(
                recipe['image_url'] ?? 'https://via.placeholder.com/150',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? '',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
