// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/models/banners_model.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../models/categories_model.dart';
import '../utils/app_utils.dart';

class HomeController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  HomeController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  final categoriesList = [].obs;

  Future<List<dynamic>> fetchBannerInfo() async {
    var list = [];
    try {
      EasyLoading.show();
      final response = await firestoreInstance
          ?.collection(AppConstants.collectionBanners)
          .get();
      EasyLoading.dismiss();
      if (response != null) {
        final documents = response.docs;
        for (var item in documents) {
          list.add(BannersModel.fromJson(item.data()));
        }
      } else {
        EasyLoading.showError(AppStrings.failToLoadBanners);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught => $e');
      }
    }
    return list;
  }

  Future<dynamic> fetchCategories() async {
    AppUtils.showHideLoader(isShow: true);
    final list = [];
    final response = await firestoreInstance
        ?.collection(AppConstants.collectionNewCategories)
        .get();
    if (response != null) {
      final docs = response.docs;
      for (var element in docs) {
        list.add(CategoriesModel.fromMap(element.data()));
      }
    }
    categoriesList.value = list;
    if (categoriesList.value.isNotEmpty) {
      categoriesList.value[0].isSelected = true;
    }
    AppUtils.showHideLoader();
    return categoriesList;
  }

  int getCurrentSelectedCategory() {
    for (var i = 0; i < categoriesList.length; i++) {
      final item = categoriesList[i];
      if (item.isSelected) {
        return i;
      }
    }
    return 0;
  }
}
