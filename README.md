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


### Project Structure
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

## Authors
- **Karima Maaoui ** - *Initial work* - [karimamaaoui](https://github.com/karimamaaoui)
![10a5ced3-8942-4c49-a521-b82b6add1522](https://github.com/user-attachments/assets/da83fcd2-a26c-404a-a9f7-854fe781b389)
![8fa43e8a-926c-4ca3-a612-c32f3fe7b719](https://github.com/user-attachments/assets/2549b959-385a-4a46-8b7a-33d4156058a7)
![ea82374d-eb9c-4639-bbec-7256f2aa2594](https://github.com/user-attachments/assets/ad46fa08-0303-4374-b0ba-5df22cc28603)
![1d821e23-d51f-4fe6-bd13-9b4b6f04fac7](https://github.com/user-attachments/assets/caa5ba75-c6be-4b1c-b67c-ab41ba305b3b)
![7bcfeee4-e3f3-4bd7-8046-7dd5d204ce08](https://github.com/user-attachments/assets/809bf0e6-252b-48ec-82c7-1d740ee36d7e)
![5b57f078-99dc-46b9-8870-6aaf925c7be7](https://github.com/user-attachments/assets/35b65603-5a2f-4513-84bd-ce091a54a42b)
![0b76c535-98a4-4844-8182-0d26b86ab91f](https://github.com/user-attachments/assets/d1dcc7ef-a2aa-46f6-9b62-68a7d193496e)
![7aa9bce0-fdd3-4f78-83f5-a0436ee16104](https://github.com/user-attachments/assets/b83905ed-10b3-43e4-8ca2-62a619cd76c6)
![e082bc09-b159-4b09-909c-e5bafdc814a0](https://github.com/user-attachments/assets/f4a43766-1222-45c1-be90-f5f3bf675f3d)
![e4994b4f-f459-4e2c-832a-90ab5bea90f0](https://github.com/user-attachments/assets/66c87b12-8609-4d06-b0b6-0001528a0f5e)
