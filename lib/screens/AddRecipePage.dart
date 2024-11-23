import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController nerController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  // Ingredients and Directions lists
  List<String> ingredients = [];
  List<String> directions = [];

  // Functions to handle adding ingredients and directions
  void _addIngredient(String ingredient) {
    setState(() {
      ingredients.add(ingredient);
    });
  }

  void _addDirection(String direction) {
    setState(() {
      directions.add(direction);
    });
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Get form data
      String title = titleController.text;
      String link = linkController.text;
      String source = sourceController.text;
      String ner = nerController.text;
      String site = siteController.text;

      // Prepare the request body
      Map<String, dynamic> body = {
        'title': title,
        'ingredients': ingredients,
        'directions': directions,
        'link': link,
        'source': source,
        'NER': ner,
        'site': site,
      };

      // Send POST request to the Flask API
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.97:5000/api/recipes'),  // Update the IP address accordingly
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recipe added successfully!')),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add recipe.')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return to the previous page (Settings page)
        Navigator.pop(context);
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Recipe')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Title input field
                  _buildTextField(
                    controller: titleController,
                    label: 'Recipe Title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  // Ingredients input field
                  _buildTextField(
                    label: 'Ingredient',
                    onFieldSubmitted: (ingredient) {
                      _addIngredient(ingredient);
                    },
                  ),
                  // Directions input field
                  _buildTextField(
                    label: 'Direction',
                    onFieldSubmitted: (direction) {
                      _addDirection(direction);
                    },
                  ),
                  // Link input field
                  _buildTextField(
                    controller: linkController,
                    label: 'Recipe Link',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a link';
                      }
                      return null;
                    },
                  ),
                  // Source input field
                  _buildTextField(
                    controller: sourceController,
                    label: 'Source',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a source';
                      }
                      return null;
                    },
                  ),
                  // NER input field
                  _buildTextField(
                    controller: nerController,
                    label: 'NER Information',
                  ),
                  // Site input field
                  _buildTextField(
                    controller: siteController,
                    label: 'Site',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a site name';
                      }
                      return null;
                    },
                  ),
                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Add Recipe', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build TextFormField with common design
  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    Function(String)? onFieldSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
