import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../models/order_model.dart';

class CheckoutController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  CheckoutController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> validateInformation(
      String name, String email, String phoneNumber) async {
    if (name == "") {
      EasyLoading.showError(AppStrings.enterName);
    } else if (email == "") {
      EasyLoading.showError(AppStrings.enterEmail);
    } else if (!GetUtils.isEmail(email)) {
      EasyLoading.showError(AppStrings.enterValidEmail);
    } else if (phoneNumber == "" || phoneNumber.length < 10) {
      EasyLoading.showError(AppStrings.enterPhoneNumber);
    } else {
      EasyLoading.show();
      return await placeOrder(name, email, phoneNumber);
    }
  }

  Future<dynamic> placeOrder(name, email, phone) async {
    try {
      final model = UserModel(
          uid: AppState.userModel?.uid,
          name: name,
          email: email,
          phoneNumber: phone);
      final ordersModel = OrderModel(
          userModel: model,
          userLocationModel: AppState.userLocationModel,
          cartItems: CartState.cartItemsList,
          userId: model.uid,
          totalPrice: CartState.getTotalAmount(),
          orderStatus: AppConstants.statusPending,
          orderDate: DateTimeUtils.fetchCurrentDate(),
          orderTime: DateTimeUtils.fetchCurrentTime());
      EasyLoading.show();
      await firestoreInstance
          ?.collection(AppConstants.collectionOrders)
          .doc()
          .set(ordersModel.toJson());
      EasyLoading.dismiss();
      EasyLoading.showSuccess(AppStrings.orderPlacedSuccess);
      return true;
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      return false;
    }
  }
}
