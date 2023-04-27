import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/home/cart_view.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'app_strings.dart';

class AppUtils {
  static void showToast(String? message) {
    if (message == null || message.isEmpty) {
      return;
    }
    EasyLoading.showToast(message,
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showHideLoader({bool isShow = false}) {
    if (isShow) {
      if (!EasyLoading.isShow) {
        EasyLoading.show();
      }
    } else if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
  }

  static void showSnackbar(String title, String message,
      {bool showButton = false, Function? callback}) async {
    TextButton showCartBtn = TextButton(
        onPressed: () async {
          Get.closeAllSnackbars();
          GoNavigation.to(() => const CartView()).then((value) {
            if (callback != null) {
              callback();
            }
          });
        },
        child: Text(AppStrings.showCart,
            style: TextStyle(color: AppColors.accentColor, fontSize: 15)));
    // remove all snackbars before showing new one
    await Get.closeCurrentSnackbar();
    Get.snackbar(title, message,
        duration: 2.seconds,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryTextColor,
        colorText: AppColors.offWhiteColor,
        margin: const EdgeInsets.all(15),
        mainButton: showButton ? showCartBtn : null);
  }

  static Color getColorBasedOnStatus(String? status) {
    if (status == null || status.isEmpty) {
      return AppColors.primaryTextColor;
    }

    if (status == AppConstants.statusPreparing) {
      return AppColors.primaryLightColor;
    } else if (status == AppConstants.statusOnRoute) {
      return AppColors.accentColor;
    } else if (status == AppConstants.statusDelivered) {
      return AppColors.secondaryTextColor;
    }
    // default case => 'Pending'
    return AppColors.primaryDarkColor;
  }

  static void shareApp() {
    Share.share(AppStrings.appShareMessage);
  }
}
