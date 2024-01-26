import 'OMRecette.dart';

class OMRecettes {
  List<OMRecette> recettes;

  OMRecettes({required this.recettes});

  static OMRecettes mock() {
    return OMRecettes(
        recettes: [OMRecette.mock('Recette 1'), OMRecette.mock('Recette 2')]);
  }
}
