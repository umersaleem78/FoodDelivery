import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_images.dart';
import 'package:food_app/views/home/dashboard_view.dart';
import 'package:get/get.dart';

class SplashView extends HookWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 3),
          () => Get.off(() => const DashboardView()));
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.offWhiteColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                AppImages.appLogo,
                width: 80,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
