import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../data/models/OMRecette.dart';

class AppData extends ChangeNotifier {
  List<OMRecette> recettes = [];
  AppDatabaseAccessor appDatabaseAccessor;
  AppDatabase database;

  AppData(this.appDatabaseAccessor, this.database) {
    loadRecettes();
  }

  Future<void> loadRecettes() async {
    recettes = await appDatabaseAccessor.getAllRecettes();
    notifyListeners();
  }

  // remove ingrédient
  void removeIngredient(String ingredient, String recetteName) async {
    await appDatabaseAccessor.removeIngredient(ingredient, recetteName);
    await loadRecettes();
  }
}
