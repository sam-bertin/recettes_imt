import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/AppData.dart';
import '../../data/models/OMRecette.dart';

class ModifyRecettePage extends StatefulWidget {
  final OMRecette recette;

  const ModifyRecettePage({Key? key, required this.recette}) : super(key: key);

  @override
  _ModifyRecettePageState createState() => _ModifyRecettePageState();
}

class _ModifyRecettePageState extends State<ModifyRecettePage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController
      _dureeController; // Ajout du contrôleur pour la durée

  late AppData appData;

  @override
  void didChangeDependencies() {
    appData = Provider.of<AppData>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs actuelles de la recette
    _nameController = TextEditingController(text: widget.recette.name);
    _descriptionController =
        TextEditingController(text: widget.recette.description);
    _dureeController = TextEditingController(
        text: widget.recette.duree
            .toString()); // Initialiser avec la valeur actuelle de la durée
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la recette'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom de la recette'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  InputDecoration(labelText: 'Description de la recette'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dureeController,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Durée de la recette (minutes)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String newRecipeName = _nameController.text;
                String newRecipeDescription = _descriptionController.text;
                int newRecipeDuree = int.tryParse(_dureeController.text) ??
                    0; // Utilisation de tryParse pour gérer le cas où la conversion échoue

                if (newRecipeName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Le nom de la recette ne peut pas être vide'),
                    ),
                  );
                  return;
                } else {
                  // Utilisez les valeurs nouvellement saisies pour la mise à jour
                  await appData.appDatabaseAccessor.updateRecette(
                    widget.recette.name,
                    newRecipeName,
                    newRecipeDescription,
                    newRecipeDuree,
                  );
                  Navigator.pop(
                      context,
                      OMRecette(
                        name: newRecipeName,
                        description: newRecipeDescription,
                        duree: newRecipeDuree,
                        ingredients: widget.recette.ingredients,
                      ));
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libérer les ressources des contrôleurs
    _nameController.dispose();
    _descriptionController.dispose();
    _dureeController.dispose();
    super.dispose();
  }
}
