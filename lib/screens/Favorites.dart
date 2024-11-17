import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:receipe_project/screens/categories/categories.dart';
import 'package:receipe_project/screens/home/homeAppbar.dart';
import 'package:receipe_project/screens/home/home_search_app.dart';
import 'package:receipe_project/screens/quick_foods/quickandfastlist.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  String currentCat = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "hello favorite"
          ),
        ),
      ),
    );
  }
}
