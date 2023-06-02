import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:isar/isar.dart';

class IsarOperations {
  static Isar? isar;

  static Future<bool> checkItemExists(ItemsModel model) async {
    final response =
        await isar?.itemsModels.filter().idEqualTo(model.id).findAll();
    if (response == null || response.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<bool?> handleFavouriteItemClick(
      ItemsModel model, Function callback) async {
    // check if the same item is already added
    final response = await checkItemExists(model);
    if (response == true) {
      await deleteFavourite(model);
      callback(true);
      return false;
    }
    return await addFavourite(model, callback);
  }

  static Future<bool?> addFavourite(ItemsModel model, Function callback) async {
    int? newAddedId = -1;
    await isar?.writeTxn(() async {
      await isar?.itemsModels.put(model).then((value) {
        newAddedId = value;
      });
    });
    if (newAddedId == null || newAddedId == -1) {
      EasyLoading.showError(AppStrings.unableToAddFavorite);
      return false;
    }
    callback(false);
    return true;
  }

  static Future<bool?> deleteFavourite(ItemsModel model) async {
    bool? isDeleted = false;
    await isar?.writeTxn(() async {
      isDeleted =
          await isar?.itemsModels.filter().idEqualTo(model.id).deleteFirst();
    });
    return isDeleted;
  }

  static Future<List<ItemsModel>?> fetchAllFavourites() async {
    return await isar?.itemsModels.where().findAll();
  }
}
