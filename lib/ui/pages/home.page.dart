import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recettes_imt/data/models/OMIngredient.dart';
import 'package:recettes_imt/ui/pages/recette.page.dart';

import '../../classes/AppData.dart';
import '../../data/models/OMRecette.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<OMRecette> recettes = [];
  List<OMRecette> filteredRecettes = [];
  String nameError = '';
  String searchQuery = '';
  late AppData appData;

  @override
  void initState() {
    super.initState();
    filteredRecettes = recettes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context);
    if (appData != null) {
      appData.loadRecettes().then((value) {
        setState(() {
          recettes = appData.recettes;
          _filterRecettes(); // Call _filterRecettes to ensure correct initial display
        });
      });
    }
  }

  void _createNewRecette() {
    showDialog(
      context: context,
      builder: (context) {
        String newRecetteName = '';
        String newRecetteDescription = '';
        int newRecetteDuration = 0;
        List<OMIngredient> newRecetteIngredients = [];

        String nameError = '';
        String ingredientsError = ''; // New error for ingredients

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Nouvelle Recette',
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        newRecetteName = value;
                        // Reset the error when the user types
                        nameError = '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      errorText: nameError.isNotEmpty ? nameError : null,
                    ),
                  ),
                  TextField(
                    onChanged: (value) => newRecetteDescription = value,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    onChanged: (value) =>
                    newRecetteDuration = int.tryParse(value) ?? 0,
                    decoration: InputDecoration(labelText: 'Durée (minutes)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _addIngredient(newRecetteIngredients, setState);
                    },
                    child: Text('Ajouter Ingrédient'),
                  ),
                  // Display the list of selected ingredients
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: newRecetteIngredients
                        .map((ingredient) => Text(
                      '- ${ingredient.name} ${ingredient.quantity} ${ingredient.unit}',
                      style: TextStyle(fontSize: 14),
                    ))
                        .toList(),
                  ),
                  // Ingredients error message
                  if (ingredientsError.isNotEmpty)
                    Text(
                      ingredientsError,
                      style:
                      TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Annuler',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Check if the name is empty
                    if (newRecetteName.isEmpty) {
                      setState(() {
                        nameError =
                        'Le nom de la recette ne peut pas être vide';
                      });
                      return;
                    }

                    //Check if name already exists
                    if (recettes.any((recette) => recette.name == newRecetteName)) {
                      setState(() {
                        nameError =
                        'Une recette avec ce nom existe déjà';
                      });
                      return;
                    }

                    // Check if the list of ingredients is empty only during recipe creation
                    if (newRecetteIngredients.isEmpty) {
                      setState(() {
                        ingredientsError =
                        'La liste d\'ingrédients ne peut pas être vide';
                      });
                      return;
                    }

                    // Create the new recette with the duration
                    OMRecette newRecette = OMRecette(
                      name: newRecetteName,
                      description: newRecetteDescription,
                      duree: newRecetteDuration,
                      ingredients: newRecetteIngredients,
                    );
                    appData.appDatabaseAccessor.addRecette(newRecette);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Créer',
                    style: TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addIngredient(List<OMIngredient> ingredients, Function setState) {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        int quantity = 0;
        String unit = '';

        return AlertDialog(
          title: Text(
            'Ajouter Ingrédient',
            style:
            TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) => quantity = int.parse(value),
                decoration: InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) => unit = value,
                decoration: InputDecoration(labelText: 'Unité'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add the new ingredient to the list
                ingredients.add(OMIngredient(
                  name: name,
                  quantity: quantity,
                  unit: unit,
                ));
                Navigator.pop(context);
                setState(
                        () {}); // Force the widget to rebuild and display the new ingredient
              },
              child: Text(
                'Ajouter',
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _filterRecettes() {
    setState(() {
      filteredRecettes = recettes
          .where((recette) =>
      recette.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          recette.description
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterRecettes();
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecettes.length,
              itemBuilder: (context, index) {
                OMRecette recette = filteredRecettes[index];
                return Dismissible(
                  key: Key(recette.name),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 32),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      recettes.remove(recette);
                    });
                    appData.appDatabaseAccessor.removeRecette(recette.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Recette supprimée",
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                  },
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    title: Text(
                      recette.name,
                      style: TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      recette.description,
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    trailing: Text(
                      "Ingrédients: ${recette.ingredients.length}",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecetteDetail(
                            recetteDeLaListe: recette,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewRecette,
        tooltip: 'Nouvelle Recette',
        child: Icon(Icons.add),
      ),
    );
  }
}
