import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_widgets.dart';

class ProductDetailView extends HookWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isItemInCart = useState(false);
    final itemsModel = Get.arguments['data'];
    isItemInCart.value = CartState.isItemInCart(itemsModel);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppWidgets.appHeader("", () => Get.back(),
                textColor: AppColors.primaryTextColor),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                itemsModel.coverImage ?? itemsModel.image,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              alignment: Alignment.topLeft,
              child: AppWidgets.appTextWithoutClick(itemsModel.name,
                  fontSize: 30,
                  isBold: true,
                  color: AppColors.primaryTextColor),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              alignment: Alignment.topLeft,
              child: AppWidgets.appTextWithoutClick(
                  itemsModel.description ?? "",
                  fontSize: 15,
                  color: AppColors.secondaryTextColor),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              alignment: Alignment.topLeft,
              child: AppWidgets.appTextWithoutClick(itemsModel.quantity,
                  fontSize: 18, color: AppColors.secondaryTextColor),
            ),
            isItemInCart.value
                ? Container(
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.bottomRight,
                    child: AppWidgets.appTextWithoutClick(
                        "${itemsModel.currency} ${itemsModel.price}",
                        fontSize: 20,
                        color: AppColors.primaryTextColor),
                  )
                : Container(),
            isItemInCart.value
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppWidgets.fetchIncrementDecrementCounter((number) {
                          if (number == 0) {
                            CartState.removeItemFromCart(itemsModel,
                                showSnackbar: true);
                            isItemInCart.value =
                                CartState.isItemInCart(itemsModel);
                          } else {
                            itemsModel.selectedQuantity = number;
                            CartState.updateQuantity(itemsModel);
                          }
                        }, initialValue: itemsModel.selectedQuantity),
                      ],
                    ),
                  )
                : Container(),
            const Spacer(),
            !isItemInCart.value
                ? InkWell(
                    onTap: () {
                      CartState.addItemInCart(itemsModel, () {});
                      isItemInCart.value = CartState.isItemInCart(itemsModel);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 20,
                          ),
                          AppWidgets.appTextWithoutClick(AppStrings.addToCart,
                              color: AppColors.offWhiteColor, fontSize: 20),
                          AppWidgets.appTextWithoutClick(
                              "${itemsModel.currency} ${itemsModel.price}",
                              fontSize: 15,
                              color: AppColors.offWhiteColor)
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
