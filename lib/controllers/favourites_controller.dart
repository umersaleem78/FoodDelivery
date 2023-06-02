import 'package:food_app/models/items_model.dart';
import 'package:get/get.dart';

import '../local/isar_operations.dart';

class FavouritesController extends GetxController {
  final favouritesList = [].obs;

  void fetchFavourites() async {
    final list = await IsarOperations.fetchAllFavourites();
    if (list != null) {
      favouritesList.value = list;
    }
  }

  void removeFromFavourites(ItemsModel model) async {
    await IsarOperations.deleteFavourite(model);
    // ignore: invalid_use_of_protected_member
    favouritesList.value.clear();
    fetchFavourites();
  }
}
