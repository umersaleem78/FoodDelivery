import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  OrdersController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> fetchUserOrders() async {
    AppUtils.showHideLoader(isShow: true);
    final docsList = [];
    final userId = AppState.userModel?.uid;
    final response = await firestoreInstance
        ?.collection(AppConstants.collectionOrders)
        .where('userId', isEqualTo: userId)
        .get();
    if (response != null) {
      final docs = response.docs;
      for (var item in docs) {
        docsList.add(OrderModel.fromJson(item.data()));
      }
      AppUtils.showHideLoader();
      return docsList;
    }
    AppUtils.showHideLoader();
    return null;
  }
}
