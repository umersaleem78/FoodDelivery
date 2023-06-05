import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:get/get.dart';

import '../local/isar_operations.dart';

class FavouritesController extends GetxController {
  Future<dynamic> fetchFavourites() async {
    final list = await IsarOperations.fetchAllFavourites();
    return list;
  }

  Future<dynamic> removeFromFavourites(ItemsModel model) async {
    await IsarOperations.deleteFavourite(model);
  }
}
