class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final int servings;
  final int prepTime; // in minutes
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.servings,
    required this.prepTime,
    required this.imageUrl,
  });

  // Factory constructor to create a Recipe instance from a JSON object
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      servings: json['servings'] as int,
      prepTime: json['prep_time'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  // Method to convert Recipe instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'servings': servings,
      'prep_time': prepTime,
      'image_url': imageUrl,
    };
  }
}
