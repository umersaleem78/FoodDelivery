import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:food_app/views/home/cancel_order_view.dart';
import 'package:food_app/views/home/order_track_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../state/cart_state.dart';
import '../../utils/app_strings.dart';

class OrderDetailView extends HookWidget {
  const OrderDetailView({super.key});

  Widget fetchOrderItem(ItemsModel model) {
    return Card(
      elevation: 5,
      color: AppColors.lightBlackColor,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                  height: 125.0,
                  width: 100.0,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: AppWidgets.appTextWithoutClick(model.name ?? "",
                        fontSize: 20,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: AppWidgets.appTextWithoutClick(
                        "${model.currency} ${model.price}",
                        fontSize: 12,
                        color: AppColors.lightWhiteColor),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: AppWidgets.appTextWithoutClick(
                        "${AppStrings.quantity}: ${model.selectedQuantity}",
                        fontSize: 14,
                        color: AppColors.textColor),
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
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        AppWidgets.appTextWithoutClick(title,
            fontSize: 13, color: AppColors.textColor),
        AppWidgets.appTextWithoutClick(amount,
            fontSize: 15,
            fontWeight: fontWeight,
            color: color ?? AppColors.lightWhiteColor)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderItem = Get.arguments['data'];
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: Column(
        children: [
          AppWidgets.appHeader(AppStrings.orderDetails, () => Get.back()),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                borderRadius: BorderRadius.circular(8)),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  fetchBottomRowWidget(
                    AppStrings.orderNo,
                    DateTimeUtils.changeDateFormat(orderItem.orderId),
                  ),
                  fetchBottomRowWidget(
                    AppStrings.orderDate,
                    DateTimeUtils.changeDateFormat(orderItem.orderDate),
                  ),
                  fetchBottomRowWidget(
                    AppStrings.orderTime,
                    DateTimeUtils.changeDateFormat(orderItem.orderTime),
                  ),
                  fetchBottomRowWidget(AppStrings.status, orderItem.orderStatus,
                      color:
                          AppUtils.getColorBasedOnStatus(orderItem.orderStatus),
                      fontWeight: FontWeight.w500),
                  InkWell(
                    onTap: () {
                      final args = {'data': orderItem.orderId};
                      Get.to(() => const OrderTrackView(), arguments: args);
                    },
                    child: Row(
                      children: [
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.delivery_dining,
                            color: AppColors.orangeColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.arrow_right,
                            color: AppColors.orangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final args = {'data': orderItem.orderId};
                      Get.to(() => const CancelOrderView(), arguments: args);
                    },
                    child: Row(
                      children: [
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.cancel,
                            color: AppColors.orangeColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.arrow_right,
                            color: AppColors.orangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 10, left: 20),
            child: AppWidgets.appText(AppStrings.items,
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
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
            elevation: 5,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: AppColors.lightBlackColor,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  fetchBottomRowWidget(AppStrings.totalItems,
                      orderItem.cartItems.length.toString(),
                      fontWeight: FontWeight.w500),
                  fetchBottomRowWidget(
                      AppStrings.subTotal, orderItem.totalPrice,
                      fontWeight: FontWeight.w300),
                  fetchBottomRowWidget(AppStrings.tax, CartState.getTax(),
                      fontWeight: FontWeight.w300),
                  fetchBottomRowWidget(AppStrings.deliveryCharges,
                      CartState.getDeliveryCharges(),
                      fontWeight: FontWeight.w300),
                  fetchBottomRowWidget(
                      AppStrings.totalAmount, orderItem.totalPrice,
                      fontWeight: FontWeight.w500)
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
