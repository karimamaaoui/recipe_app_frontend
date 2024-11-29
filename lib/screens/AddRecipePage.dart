import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipe_project/constants/constant.dart';

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
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController directionController = TextEditingController();

  // Ingredients and Directions lists
  List<String> ingredients = [];
  List<String> directions = [];

  // Functions to handle adding ingredients and directions
  void _addIngredient() {
    if (ingredientController.text.isNotEmpty) {
      setState(() {
        ingredients.add(ingredientController.text);
        ingredientController.clear();
      });
    }
  }

  void _addDirection() {
    if (directionController.text.isNotEmpty) {
      setState(() {
        directions.add(directionController.text);
        directionController.clear();
      });
    }
  }
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
          Uri.parse('$baseUrl/api/recipes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          // Clear all text fields and lists after successful submission
          setState(() {
            titleController.clear();
            linkController.clear();
            sourceController.clear();
            nerController.clear();
            siteController.clear();
            ingredientController.clear();
            directionController.clear();
            ingredients.clear();
            directions.clear();
          });

          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Recipe added successfully!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
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
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Add Recipe')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  controller: titleController,
                  label: 'Recipe Title',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: ingredientController,
                        label: 'Ingredient',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addIngredient,
                    ),
                  ],
                ),
                _buildListDisplay('Ingredients:', ingredients),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: directionController,
                        label: 'Direction',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addDirection,
                    ),
                  ],
                ),
                _buildListDisplay('Directions:', directions),
                _buildTextField(
                  controller: linkController,
                  label: 'Recipe Link',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a link' : null,
                ),
                _buildTextField(
                  controller: sourceController,
                  label: 'Source',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a source' : null,
                ),
                _buildTextField(
                  controller: nerController,
                  label: 'NER Information',
                ),
                _buildTextField(
                  controller: siteController,
                  label: 'Site',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a site name' : null,
                ),
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
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildListDisplay(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(title: Text(item))),
      ],
    );
  }
}
