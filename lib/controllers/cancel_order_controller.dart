import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:get/get.dart';

class CancelOrderController extends GetxController {
  FirebaseFirestore? _instance;

  CancelOrderController() {
    _instance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> sendCancelOrderCall(
      String orderId, String cancellationReason, Function callback) async {
    AppUtils.showHideLoader(isShow: true);
    final response = await _instance
        ?.collection(AppConstants.collectionOrders)
        .where('orderId', isEqualTo: orderId)
        .get();
    if (response != null && response.size > 0) {
      final map = <String, dynamic>{};
      map["orderStatus"] = AppConstants.statusCancelled;
      map["cancellationReason"] = cancellationReason;
      await _instance
          ?.collection(AppConstants.collectionOrders)
          .doc(response.docs[0].id)
          .update(map)
          .then((value) {
        callback();
      }).onError((error, stackTrace) {
        EasyLoading.showError(AppStrings.somethingWentWrong);
        if (kDebugMode) {
          print('Error while updating entry => $error');
        }
      });
    } else {
      AppUtils.showHideLoader();
      EasyLoading.showError(AppStrings.somethingWentWrong);
    }
  }
}
