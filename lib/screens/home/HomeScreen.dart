import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:receipe_project/constants.dart';
import 'package:receipe_project/screens/FavoritePage.dart';
import 'package:receipe_project/screens/RecipeSearch.dart';
import 'package:receipe_project/screens/home/RecipeHomePage.dart';
import 'package:receipe_project/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  List screens= [
    RecipeHomePage(),
    FavoritePage(),
    const RecipeSearch(),
    const Settings()
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: ()=>setState(() {
                currentTab=0;
              }),
              child: Column(
                children: [
                  Icon(
                    BoxIcons.bx_home,
                    color: currentTab == 0 ? primaryColor : Colors.grey,
                    size: 24.0,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 0 ? primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=>setState(() {
                currentTab=1;
              }),
              child: Column(
                children: [
                  Icon(
                    BoxIcons.bx_heart,
                    color: currentTab == 1 ? primaryColor : Colors.grey,
                    size: 24.0,
                  ),
                  Text(
                    "Favorites",
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 1 ? primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: ()=>setState(() {
                currentTab=2;
              }),
              child: Column(
                children: [
                  Icon(
                    BoxIcons.bx_calendar,
                    color: currentTab == 2 ? primaryColor : Colors.grey,
                    size: 24.0,
                  ),
                  Text(
                    "Meal Plan",
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 2 ? primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=>setState(() {
                currentTab=3;
              }),
              child: Column(
                children: [
                  Icon(
                    BoxIcons.bx_cog,
                    color: currentTab == 3 ? primaryColor : Colors.grey,
                    size: 24.0,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 3 ? primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: screens[currentTab],
    );
  }
}
