class OMIngredient {
  final String name;
  final int quantity;
  final String unit;

  const OMIngredient(
      {required this.name, required this.quantity, required this.unit});

  static OMIngredient mock(ingredientName) {
    return OMIngredient(name: ingredientName, quantity: 100, unit: 'g');
  }

  @override
  String toString() {
    return 'Ingredient: $name, $quantity, $unit';
  }
}
