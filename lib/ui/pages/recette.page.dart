import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recettes_imt/data/models/OMIngredient.dart';
import 'package:recettes_imt/ui/pages/update.page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../classes/AppData.dart';
import '../../data/models/OMRecette.dart';

class RecetteDetail extends StatefulWidget {
  final OMRecette recetteDeLaListe;

  const RecetteDetail({Key? key, required this.recetteDeLaListe})
      : super(key: key);

  @override
  State<RecetteDetail> createState() => _RecetteDetailState();
}

class _RecetteDetailState extends State<RecetteDetail> {
  late OMRecette recetteAffichee;
  late AppData appData;

  @override
  void initState() {
    recetteAffichee = widget.recetteDeLaListe;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appData = Provider.of<AppData>(context);
    super.didChangeDependencies();
  }

  void _removeIngredient(int index) {
    setState(() {
      recetteAffichee.ingredients.removeAt(index);
    });
  }

  void _shareRecipeViaSMS() async {
    final String message = 'Regarde ma nouvelle necette:\n\n'
        'Nom: ${recetteAffichee.name}\n'
        'Description: ${recetteAffichee.description}\n'
        'Durée: ${recetteAffichee.duree} minutes\n'
        'Ingredients:\n${recetteAffichee.ingredients.map((ingredient) => '- ${ingredient.name} ${ingredient.quantity} ${ingredient.unit}').join('\n')}';

    final Uri uri = Uri(scheme: 'sms', queryParameters: {'body': message});

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      // Handle the error
      print('Could not launch SMS');
    }
  }

  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        int quantity = 0;
        String unit = '';

        return AlertDialog(
          title: Text('Ajouter un ingrédient'),
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
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // ajouter l'ingredient en base
                appData.appDatabaseAccessor.addIngredient(
                  recetteAffichee.name,
                  name,
                  quantity,
                  unit,
                );
                setState(() {
                  recetteAffichee.ingredients.add(
                      OMIngredient(name: name, quantity: quantity, unit: unit));
                });
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recetteAffichee.name,
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ModifyRecettePage(recette: recetteAffichee),
                ),
              ).then((value) {
                setState(() {
                  recetteAffichee = value;
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () => _shareRecipeViaSMS(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer, size: 24), // Icône de durée
                SizedBox(width: 8),
                Text(
                  '${recetteAffichee.duree} minutes',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              recetteAffichee.description,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Ingrédients:',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  List.generate(recetteAffichee.ingredients.length, (index) {
                var ingredient = recetteAffichee.ingredients[index];
                return Dismissible(
                  key: Key('$index${ingredient.name}'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 32),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    // Supprimer l'ingrédient
                    appData.appDatabaseAccessor.removeIngredient(
                      ingredient.name,
                      recetteAffichee.name,
                    );
                    _removeIngredient(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Ingrédient supprimé"),
                      ),
                    );
                  },
                  direction: DismissDirection.endToStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text:
                                        '${ingredient.name} ${ingredient.quantity} ${ingredient.unit}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(children: [
                                Icon(Icons.arrow_back),
                                Icon(Icons.delete)
                              ])),
                        ],
                      ),
                      Divider(), // Ajout du séparateur
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIngredient,
        tooltip: 'Add Ingredient',
        child: Icon(Icons.add),
      ),
    );
  }
}
