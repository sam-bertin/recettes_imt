import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:recettes_imt/data/models/OMIngredient.dart';
import 'package:recettes_imt/data/models/OMRecette.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DataClassName('RecetteTable')
class Recette extends Table {
  TextColumn get name => text()();

  TextColumn get description => text()();

  IntColumn get duree => integer()();

  @override
  Set<Column> get primaryKey => {name};
}

@DataClassName('IngredientTable')
class Ingredient extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get recetteName =>
      text().customConstraint('REFERENCES recette(name)').nullable()();

  TextColumn get name => text()();

  IntColumn get quantity => integer()();

  TextColumn get unit => text()();
}

@DriftDatabase(tables: [Recette, Ingredient])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [Recette, Ingredient])
class AppDatabaseAccessor extends DatabaseAccessor<AppDatabase>
    with _$AppDatabaseAccessorMixin {
  AppDatabaseAccessor(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<OMRecette>> getAllRecettes() async {
    List<RecetteTable> recettesTable = await select(db.recette).get();
    // convert RecetteTable to OMRecette
    return Future.wait(recettesTable.map((recetteTable) async {
      return OMRecette(
        name: recetteTable.name,
        description: recetteTable.description,
        duree: recetteTable.duree,
        ingredients: await getAllIngredientsPourRecetteDeNom(recetteTable.name),
      );
    }).toList());
  }

  Future<List<OMIngredient>> getAllIngredientsPourRecetteDeNom(
      recetteName) async {
    Future<List<IngredientTable>> ingredientsDeLaRecette = (select(
            db.ingredient)
          ..where((ingredient) => ingredient.recetteName.equals(recetteName)))
        .get();
    // convert IngredientTable to OMIngredient
    return ingredientsDeLaRecette.then((ingredientsTable) {
      return ingredientsTable.map((ingredientTable) {
        return OMIngredient(
          name: ingredientTable.name,
          quantity: ingredientTable.quantity,
          unit: ingredientTable.unit,
        );
      }).toList();
    });
  }

  Future<void> updateRecette(String recetteName, String newRecetteName,
      String newDescription, int newDuree) async {
    // modification de la recette et des ingredients qui y étaient associés
    await (update(db.recette)
          ..where((recette) => recette.name.equals(recetteName)))
        .write(RecetteTable(
            name: newRecetteName,
            description: newDescription,
            duree: newDuree));
    // modification des ingredients qui étaient associés à la recette
    await (update(db.ingredient)
          ..where((ingredient) => ingredient.recetteName.equals(recetteName)))
        .write(IngredientCompanion(
      recetteName: Value(newRecetteName),
    ));
    print('updateNameAndDescriptionOfRecette');
  }

  // get OMRecette by name
  Future<OMRecette> getRecetteByName(String recetteName) async {
    RecetteTable recetteTable = await (select(db.recette)
          ..where((recette) => recette.name.equals(recetteName)))
        .getSingle();
    // convert RecetteTable to OMRecette
    return OMRecette(
      name: recetteTable.name,
      description: recetteTable.description,
      duree: recetteTable.duree,
      ingredients: await getAllIngredientsPourRecetteDeNom(recetteTable.name),
    );
  }

  // remove ingrédient
  Future<void> removeIngredient(String ingredient, String recetteName) async {
    print('removeIngredient');
    await (delete(db.ingredient)
          ..where((ingredientTable) =>
              ingredientTable.recetteName.equals(recetteName) &
              ingredientTable.name.equals(ingredient)))
        .go();
  }

  // add ingredient
  void addIngredient(
      String recetteName, String name2, int quantity, String unit) {
    into(db.ingredient).insertOnConflictUpdate(IngredientCompanion.insert(
        recetteName: Value(recetteName),
        name: name2,
        quantity: quantity,
        unit: unit));
  }

  // add recette and its ingredients
  void addRecette(OMRecette recette) {
    into(db.recette).insertOnConflictUpdate(RecetteCompanion.insert(
      name: recette.name,
      description: recette.description,
      duree: recette.duree,
    ));
    recette.ingredients.forEach((ingredient) {
      addIngredient(
          recette.name, ingredient.name, ingredient.quantity, ingredient.unit);
    });
  }

  // remove recette and its ingredients
  void removeRecette(String name) {
    (delete(db.recette)..where((recette) => recette.name.equals(name))).go();
    (delete(db.ingredient)
          ..where((ingredient) => ingredient.recetteName.equals(name)))
        .go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
