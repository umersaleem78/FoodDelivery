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
    final updateData = useState(false);
    isItemInCart.value = CartState.isItemInCart(itemsModel);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
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
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    alignment: Alignment.topLeft,
                    child: AppWidgets.appTextWithoutClick(itemsModel.name,
                        fontSize: 15,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.bottomRight,
                    child: AppWidgets.appTextWithoutClick(
                        "${itemsModel.currency} ${itemsModel.price}",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.orangeColor),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              alignment: Alignment.topLeft,
              child: AppWidgets.appTextWithoutClick(
                  itemsModel.description ?? "",
                  fontSize: 12,
                  color: AppColors.lightWhiteColor),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.goldenYellow),
                      Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: AppWidgets.appTextWithoutClick(
                              (itemsModel.rating ?? "0").toString(),
                              color: AppColors.textColor,
                              fontSize: 12))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.food_bank, color: AppColors.orangeColor),
                      Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: AppWidgets.appTextWithoutClick(
                              "${itemsModel.quantity} | ${itemsModel.calories}",
                              color: AppColors.textColor,
                              fontSize: 12))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer, color: AppColors.orangeColor),
                      Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: AppWidgets.appTextWithoutClick(
                              itemsModel.preparationTime,
                              color: AppColors.textColor,
                              fontSize: 12))
                    ],
                  )
                ],
              ),
            ),
            isItemInCart.value
                ? Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(right: 10),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 200,
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              child: AppWidgets.fetchIncrementDecrementCounter(
                                  (number) {
                            if (number == 0) {
                              CartState.removeItemFromCart(itemsModel,
                                  showSnackbar: true);
                              isItemInCart.value =
                                  CartState.isItemInCart(itemsModel);
                            } else {
                              itemsModel.selectedQuantity = number;
                              CartState.updateQuantity(itemsModel);
                              updateData.value = !updateData.value;
                            }
                          }, initialValue: itemsModel.selectedQuantity)),
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: AppWidgets.appTextWithoutClick(
                                  "${itemsModel.currency} ${(itemsModel.price ?? 1) * (itemsModel.selectedQuantity ?? 1)}",
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 50)),
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
                            color: AppColors.orangeColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: AppWidgets.appTextWithoutClick(
                            AppStrings.addToCart,
                            color: AppColors.whilteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
