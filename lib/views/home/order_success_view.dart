import 'package:flutter/material.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/views/home/dashboard_view.dart';
import 'package:food_app/views/home/order_track_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments['data'];
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.delivery_dining,
                color: AppColors.orangeColor,
                size: 150,
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: AppWidgets.appTextWithoutClick(AppStrings.successful,
                      color: AppColors.orangeColor, fontSize: 35),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppWidgets.appTextWithoutClick(
                      AppStrings.orderSuccessfulMessage,
                      color: AppColors.textColor,
                      fontSize: 15),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: AppWidgets.appButton(AppStrings.trackOrder, () {
                    final args = {'data': orderId};
                    Get.to(() => const OrderTrackView(), arguments: args);
                  }),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: AppWidgets.appButton(AppStrings.goBackToHome,
                      () => Get.offAll(() => const DashboardView())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
