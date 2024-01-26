import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recettes_imt/data/models/OMRecettes.dart';
import 'package:recettes_imt/ui/pages/home.page.dart';

import 'classes/AppData.dart';
import 'data/db/database.dart';
import 'data/models/OMRecette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final appDatabaseAccessor = AppDatabaseAccessor(database);

  // delete all data
  //await database.delete(database.ingredient).go();
  //await database.delete(database.recette).go();

  // add recettes and ingredients
  //await addData(database);

  // create the Recette objects from recettes
  OMRecettes recettes = await obtenirRecettes(appDatabaseAccessor);

  // show all the recettes by printing them to the console
  recettes.recettes.forEach((recette) {
    print(recette);
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(appDatabaseAccessor, database),
      child: MaterialApp(
        title: 'Recettes IMT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => MyHomePage(title: 'Recettes IMT'),
        },
      ),
    ),
  );
}

Future<OMRecettes> obtenirRecettes(
    AppDatabaseAccessor appDatabaseAccessor) async {
  // create the Recette objects from recettes
  List<OMRecette> listeRecettes = await appDatabaseAccessor.getAllRecettes();
  // create the Recettes object from recettesOM
  OMRecettes recettesObjet = OMRecettes(recettes: listeRecettes);
  return recettesObjet;
}

Future<void> addData(AppDatabase database) async {
  // add recette
  await database.into(database.recette).insertOnConflictUpdate(
      RecetteCompanion.insert(
          name: "Pain", description: 'Pain fait maison', duree: 10));
  // link ingredient to recette
  await database.into(database.ingredient).insertOnConflictUpdate(
      IngredientCompanion.insert(
          recetteName: Value("Pain"),
          name: 'Farine',
          quantity: 100,
          unit: 'g'));
  await database.into(database.ingredient).insertOnConflictUpdate(
      IngredientCompanion.insert(
          recetteName: Value("Pain"), name: 'Eau', quantity: 50, unit: 'cl'));

  // add recette
  await database.into(database.recette).insertOnConflictUpdate(
      RecetteCompanion.insert(
          name: "Pain au chocolat",
          description: 'Pain au chocolat fait maison',
          duree: 20));
  // link ingredient to recette
  await database.into(database.ingredient).insertOnConflictUpdate(
      IngredientCompanion.insert(
          recetteName: Value("Pain au chocolat"),
          name: 'Farine',
          quantity: 100,
          unit: 'g'));
  await database.into(database.ingredient).insertOnConflictUpdate(
      IngredientCompanion.insert(
          recetteName: Value("Pain au chocolat"),
          name: 'Eau',
          quantity: 50,
          unit: 'cl'));
  await database.into(database.ingredient).insertOnConflictUpdate(
      IngredientCompanion.insert(
          recetteName: Value("Pain au chocolat"),
          name: 'Chocolat',
          quantity: 50,
          unit: 'g'));
}
