import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:get/get.dart';

class OrderTrackController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  OrderTrackController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic>? fetchOrder(String? orderId) async {
    if (orderId == null || orderId.isEmpty) {
      EasyLoading.showError(AppStrings.invalidOrderIdFound);
      return null;
    }
    EasyLoading.show();
    try {
      final response = await firestoreInstance
          ?.collection(AppConstants.collectionOrders)
          .where('orderId', isEqualTo: orderId)
          .get();
      EasyLoading.dismiss();
      if (response != null && response.size > 0) {
        return OrderModel.fromJson(response.docs[0].data());
      } else {
        EasyLoading.showInfo(AppStrings.invalidOrderIdFound);
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(AppStrings.somethingWentWrong);
      return null;
    }
  }
}
