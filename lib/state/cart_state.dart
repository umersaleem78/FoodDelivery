import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/utils/app_strings.dart';

class CartState {
  static final cartItemsList = [];

  static void addItemInCart(ItemsModel model, Function callback) {
    if (cartItemsList.contains(model)) {
      EasyLoading.showInfo(AppStrings.itemInCart);
    } else {
      // set quantity back to '1', if it was previously added and quantity was changed
      model.selectedQuantity = 1;
      cartItemsList.add(model);
      // final message = "${model.name} ${AppStrings.addedSuccessfully}";
      // AppUtils.showSnackbar(AppStrings.info, message,
      //     showButton: true, callback: () => callback());
    }
  }

  static void removeItemFromCart(ItemsModel model,
      {bool showSnackbar = false}) {
    if (cartItemsList.contains(model)) {
      cartItemsList.remove(model);
      // don't show snackbar when removing from cart view
      // if (showSnackbar) {
      //   final message = "${model.name} ${AppStrings.removedSuccessfully}";
      //   AppUtils.showSnackbar(AppStrings.info, message,
      //       showButton: false, callback: () {});
      // }
    }
  }

  static void clearCart() {
    cartItemsList.clear();
  }

  static bool isItemInCart(ItemsModel model) {
    return cartItemsList.contains(model);
  }

  static int getItemQuantity(ItemsModel model) {
    if (cartItemsList.contains(model)) {
      return cartItemsList[cartItemsList.indexOf(model)].selectedQuantity;
    }
    return 1;
  }

  static void updateQuantity(ItemsModel model) {
    if (cartItemsList.contains(model)) {
      int index = cartItemsList.indexOf(model);
      cartItemsList[index].selectedQuantity = model.selectedQuantity;
    }
  }

  static String fetchCurrency() {
    if (cartItemsList.isNotEmpty) {
      return cartItemsList[0].currency;
    }
    return "";
  }

  static String fetchSubTotalAmount({bool returnWithCurrency = true}) {
    var totalPrice = 0;

    for (var element in cartItemsList) {
      var itemPrice = (element.price as int) * (element.selectedQuantity ?? 1);
      totalPrice += itemPrice as int;
    }
    if (!returnWithCurrency) {
      return totalPrice.toString();
    }
    return "${fetchCurrency()} $totalPrice";
  }

  static String getDeliveryCharges() {
    return "0";
  }

  static String getTax() {
    return "0";
  }

  static String getTotalAmount() {
    final subTotal = fetchSubTotalAmount(returnWithCurrency: false);
    final deliveryCharges = getDeliveryCharges();
    final tax = getTax();
    return "${fetchCurrency()} ${int.parse(subTotal) + int.parse(deliveryCharges) + int.parse(tax)}";
  }
}
