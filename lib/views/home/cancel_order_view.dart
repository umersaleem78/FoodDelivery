import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../utils/app_strings.dart';
import '../../widgets/app_widgets.dart';

class CancelOrderView extends HookWidget {
  const CancelOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments['data'];
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: Column(
        children: [
          AppWidgets.appHeader(AppStrings.cancelOrder, () => Get.back()),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 20, top: 25),
            child: AppWidgets.appText(AppStrings.cancelOrderTitle,
                color: AppColors.textColor, fontSize: 15),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Divider(
              height: 5,
              color: AppColors.textColor,
            ),
          )
        ],
      )),
    );
  }
}
