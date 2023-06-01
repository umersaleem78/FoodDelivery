import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/controllers/order_track_controller.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/utils/location_utils.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class OrderTrackView extends HookWidget {
  const OrderTrackView({super.key});

  Widget fetchOrderStatusView(String name, IconData icon, String? orderStatus) {
    final isSameStatus = (name == orderStatus);
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSameStatus == true
              ? AppUtils.getColorBasedOnStatus(orderStatus)
              : AppColors.blackColor),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.lightWhiteColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: AppWidgets.appTextWithoutClick(name,
                color: AppColors.lightWhiteColor, fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderModel = useState(OrderModel());
    final orderId = Get.arguments['data'];
    final controller = Get.find<OrderTrackController>();
    final location = useState('');
    useEffect(() {
      controller.fetchOrder(orderId)?.then((value) {
        orderModel.value = value;
        LocationUtils.fetchSubLocalityFromCoordinates(
                orderModel.value.userLocationModel?.latitude,
                orderModel.value.userLocationModel?.longitude)
            .then((value) {
          if (value != null) {
            location.value = value as String;
          }
        });
      });
      return null;
    }, [null]);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.appHeader(AppStrings.trackOrder, () => Get.back()),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                borderRadius: BorderRadius.circular(8)),
            height: 125,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fetchOrderStatusView(AppConstants.statusPending,
                    Icons.watch_later, orderModel.value.orderStatus),
                fetchOrderStatusView(AppConstants.statusPreparing,
                    Icons.work_outline, orderModel.value.orderStatus),
                fetchOrderStatusView(AppConstants.statusOnRoute,
                    Icons.delivery_dining, orderModel.value.orderStatus),
                fetchOrderStatusView(AppConstants.statusDelivered, Icons.done,
                    orderModel.value.orderStatus)
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: AppWidgets.appTextWithoutClick(AppStrings.orderNumber,
                  color: AppColors.textColor, fontSize: 15)),
          Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lightBlackColor),
              child: AppWidgets.appTextWithoutClick(
                  orderModel.value.orderId ?? "",
                  color: AppColors.orangeColor)),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: const EdgeInsets.all(10),
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.lightBlackColor),
            child: Column(children: [
              AppWidgets.appTextWithoutClick(
                  orderModel.value.userLocationModel?.address ?? "",
                  color: AppColors.textColor,
                  fontSize: 12),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Divider(
                  height: 2,
                  color: AppColors.orangeColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later,
                          color: AppColors.textColor,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: AppWidgets.appTextWithoutClick(
                              "${CartState.fetchTotalPrepartionTime(orderModel.value.cartItems)} ${AppStrings.timeUnit}",
                              color: AppColors.lightWhiteColor,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: AppColors.textColor,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: AppWidgets.appTextWithoutClick(location.value,
                              color: AppColors.lightWhiteColor, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: AppWidgets.appTextWithoutClick(
                        orderModel.value.orderStatus ==
                                AppConstants.statusDelivered
                            ? AppStrings.deliveryTime
                            : AppStrings.estimatedDeliveryTime,
                        color: AppColors.textColor,
                        fontSize: 12),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 5),
                    child: AppWidgets.appTextWithoutClick(AppStrings.homeCity,
                        color: AppColors.textColor, fontSize: 12),
                  )
                ],
              ),
            ]),
          )
        ],
      )),
    );
  }
}
