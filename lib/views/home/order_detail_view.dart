import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../state/cart_state.dart';
import '../../utils/app_strings.dart';

class OrderDetailView extends HookWidget {
  const OrderDetailView({super.key});

  Widget fetchOrderItem(ItemsModel model) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  model.image ?? "",
                  height: 150.0,
                  width: 100.0,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppWidgets.appTextWithoutClick(model.name ?? "",
                        isBold: true,
                        fontSize: 18,
                        color: AppColors.primaryTextColor),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: AppWidgets.appTextWithoutClick(
                        "${model.currency} ${model.price}",
                        fontSize: 18,
                        color: AppColors.secondaryTextColor),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: AppWidgets.appTextWithoutClick(
                        "${AppStrings.quantity} ${model.selectedQuantity}",
                        fontSize: 18,
                        color: AppColors.primaryTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fetchBottomRowWidget(String title, String amount,
      {Color? color, bool isBold = true}) {
    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        AppWidgets.appTextWithoutClick(title,
            fontSize: 13, color: AppColors.primaryTextColor),
        AppWidgets.appTextWithoutClick(amount,
            fontSize: 18,
            isBold: isBold,
            color: color ?? AppColors.primaryTextColor)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderItem = Get.arguments['data'];
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AppWidgets.appHeader("", () => Get.back()),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  fetchBottomRowWidget(AppStrings.orderDate,
                      DateTimeUtils.changeDateFormat(orderItem.orderDate),
                      isBold: false),
                  fetchBottomRowWidget(AppStrings.orderTime,
                      DateTimeUtils.changeDateFormat(orderItem.orderTime),
                      isBold: false),
                  fetchBottomRowWidget(AppStrings.status, orderItem.orderStatus,
                      color: AppUtils.getColorBasedOnStatus(
                          orderItem.orderStatus)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                  itemCount: orderItem.cartItems.length,
                  itemBuilder: (context, index) {
                    return fetchOrderItem(orderItem.cartItems[index]);
                  }),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  fetchBottomRowWidget(AppStrings.totalItems,
                      orderItem.cartItems.length.toString(),
                      isBold: false),
                  fetchBottomRowWidget(
                      AppStrings.subTotal, orderItem.totalPrice,
                      isBold: false),
                  fetchBottomRowWidget(AppStrings.tax, CartState.getTax(),
                      isBold: false),
                  fetchBottomRowWidget(AppStrings.deliveryCharges,
                      CartState.getDeliveryCharges(),
                      isBold: false),
                  fetchBottomRowWidget(
                      AppStrings.totalAmount, orderItem.totalPrice)
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
