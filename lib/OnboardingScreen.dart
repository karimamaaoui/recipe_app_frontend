import 'package:flutter/material.dart';
import 'package:receipe_project/components/dot_indicators.dart';
import 'package:receipe_project/constants.dart';
import 'package:receipe_project/screens/auth/login_screen.dart';
import 'package:receipe_project/screens/onboarding/components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Get Started".toUpperCase(),
                  style: TextStyle(backgroundColor: primaryColor),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/Illustrations/Illustrations_1.svg",
    "title": "Enjoy",
    "text":
        "Start with foods recipes you enjoy \nsearch for the foods you know you \nlike, find a trusted recipe source.",
  },
  {
    "illustration": "assets/Illustrations/cook2.svg",
    "title": "Cook",
    "text":
        "Cooking your favorite recipe \n became esay now, you just need \n to follow the steps",
  },
  {
    "illustration": "assets/Illustrations/cook2.svg",
    "title": "Be Confident",
    "text":
        "You can do this. Step up to the \n cutting board, the oven , or the \n stovetop with full confidence in  \nyour abilities",
  },
];
