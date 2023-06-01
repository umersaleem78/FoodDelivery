// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/orders_controller.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/home/order_detail_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OrdersView extends HookWidget {
  const OrdersView({super.key});

  Widget fetchOrderItem(OrderModel model) {
    return InkWell(
      onTap: () {
        final args = {'data': model};
        GoNavigation.to(() => const OrderDetailView(), arguments: args);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(children: [
                    Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidgets.appTextWithoutClick(AppStrings.orderNo,
                    color: AppColors.textColor, fontSize: 15),
                AppWidgets.appTextWithoutClick(
                    DateTimeUtils.changeDateFormat(model.orderId.toString()),
                    color: AppColors.lightWhiteColor,
                    fontSize: 15,),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidgets.appTextWithoutClick(AppStrings.orderDate,
                    color: AppColors.textColor, fontSize: 15),
                AppWidgets.appTextWithoutClick(
                    DateTimeUtils.changeDateFormat(model.orderDate),
                    color: AppColors.lightWhiteColor,
                    fontSize: 15,),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidgets.appTextWithoutClick(AppStrings.orderTime,
                    color: AppColors.textColor, fontSize: 15),
                AppWidgets.appTextWithoutClick(
                    DateTimeUtils.changeDateFormat(model.orderTime),
                    color: AppColors.lightWhiteColor,
                    fontSize: 15),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidgets.appTextWithoutClick(AppStrings.orderStatus,
                    color: AppColors.textColor, fontSize: 15),
                AppWidgets.appTextWithoutClick(model.orderStatus ?? "",
                    color: AppUtils.getColorBasedOnStatus(model.orderStatus),
                    fontSize: 18,fontWeight: FontWeight.w500),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidgets.appTextWithoutClick(AppStrings.totalAmount,
                    color: AppColors.textColor, fontSize: 15),
                AppWidgets.appTextWithoutClick(model.totalPrice ?? "",
                    color: AppColors.lightWhiteColor,
                    fontSize: 18,fontWeight: FontWeight.w600),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.symmetric(vertical: 3),
              child: IconButton(
                icon: Icon(Icons.arrow_circle_right,color: AppColors.orangeColor,),
                onPressed: () {},
              )),
          Divider(
            color: AppColors.dividerColor,
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final isUserLoggedIn = useState(false);
    final ordersList = useState([]);
    final myOrders = useState(AppStrings.myOrders);

    Future<dynamic> fetchUserOrders() async {
      return controller.fetchUserOrders();
    }

    void checkLoginStatus() async {
      isUserLoggedIn.value = AppState.userModel != null;
      if (isUserLoggedIn.value && ordersList.value.isEmpty) {
        final response = await fetchUserOrders();
        if (response != null) {
          ordersList.value = response;
          myOrders.value =
              "${AppStrings.myOrders} (${ordersList.value.length})";
        }
      }
    }

    useEffect(() {
      checkLoginStatus();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (info) => checkLoginStatus(),
        child: isUserLoggedIn.value
            ? Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                    alignment: Alignment.topLeft,
                    child: AppWidgets.appTextWithoutClick(myOrders.value,
                        color: AppColors.textColor,
                        fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: ordersList.value.length,
                        itemBuilder: ((context, index) {
                          return fetchOrderItem(ordersList.value[index]);
                        })),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: AppWidgets.appTextWithoutClick(
                    AppStrings.pleaseLoginToViewThisPage,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor),
              ),
      )),
    );
  }
}
