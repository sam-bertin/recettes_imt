import 'OMIngredient.dart';

class OMRecette {
  final String name;
  final String description;
  final int duree;
  final List<OMIngredient> ingredients;

  const OMRecette({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.duree,
  });

  set imageUrl(String imageUrl) {}

  static OMRecette mock(recetteName) {
    return OMRecette(
        name: recetteName,
        description: 'description1',
        duree: 10,
        ingredients: [
          OMIngredient.mock('ingredient1'),
          OMIngredient.mock('ingredient2')
        ]);
  }

  @override
  String toString() {
    return 'OMRecette{name: $name, description: $description, duree: $duree, ingredients: $ingredients}';
  }
}
