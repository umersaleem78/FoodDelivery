import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/categories_model.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';

class ProductsController extends GetxController {
  FirebaseFirestore? firestoreInstance;
  final categoriesList = [].obs;

  ProductsController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> fetchCategories() async {
    AppUtils.showHideLoader(isShow: true);
    final list = [];
    final response = await firestoreInstance
        ?.collection(AppConstants.collectionNewCategories)
        .get();
    if (response != null) {
      categoriesList.clear();
      final docs = response.docs;
      for (var element in docs) {
        list.add(CategoriesModel.fromMap(element.data()));
      }
    }
    for (var item in list) {
      categoriesList.add(item);
    }
    AppUtils.showHideLoader();
    return categoriesList;
  }
}
