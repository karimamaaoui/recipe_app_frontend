# Recipe App

Welcome to the **Recipe App**, a Flutter-based application that helps users explore, save, and share their favorite recipes. This app allows users to browse recipes, search for ingredients, and view detailed steps for preparation.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Authors](#authors)

## Features

- **Browse Recipes**: Users can view a list of available recipes with their basic details ( title, ingredients ,image).
- **Search Recipes**: Search for recipes by ingredient.
- **Recipe Details**: View detailed information including ingredients, preparation steps and images.
- **Add Recipes**: Users can add new recipes with fields for ingredients,directions, Source, and images.
- **Favorites**: Save your favorite recipes for easy access later.
- **Categories**: Browse recipes by categories such as "Tomato," "Vanilla," "Chocolate," "Carrot," etc.

## Installation

Follow these steps to install and run the Recipe App on your local machine:

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0 or higher)
- A code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- Android or iOS emulator, or a physical device for testing

### Steps

1. **Clone the repository** to your local machine:

   ```bash
   git clone https://github.com/karimamaaoui/recipe_app_frontend.git

2. **Navigate to the project directory :**
   cd recipe_app_frontend
3. **Install dependencies using Flutter:**
   flutter pub get
4. **Run the app:**
   flutter run


### Detailed Folder Structure
lib/
├── components/             # Contains reusable components (buttons, banners, etc.)
│   ├── buttons/            # Buttons components
│   │   ├── banner.dart     # Banner button component
│   │   ├── dot_indicators.dart # Dot indicators component
│   │   ├── ScaffoldCustom.dart # Custom scaffold component
│   │   └── welcome_text.dart  # Welcome text component
├── constants/              # Stores constant values and configurations
│   ├── constant.dart       # A single constant configuration file
│   └── constants.dart      # Another constants file
├── screens/                # Contains all screens of the app
│   ├── auth/               # Authentication-related screens
│   ├── home/               # Main home screen of the app
│   └── onboarding/         # Onboarding-related screens
│       ├── AddRecipePage.dart # Screen for adding a new recipe
│       ├── FavoritePage.dart # Screen for viewing favorite recipes
│       ├── RecipeDetailsPage.dart # Recipe details screen
│       ├── RecipeSearch.dart # Search recipe screen
│       ├── RecipeService.dart # Service to manage recipe data
│       ├── ServiceFavorite.dart # Service to manage favorites
│       └── settings.dart   # Settings screen for user preferences
├── BaseAPI.dart            # API base connection file
├── main.dart               # Main entry point of the app
└── OnboardingScreen.dart   # Onboarding screen (initial intro)

### Authors
Karima Maaoui - Initial work - karimamaaoui