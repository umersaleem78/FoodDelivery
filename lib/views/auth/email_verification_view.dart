import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/email_verification_controller.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';

class EmailVerificationView extends HookWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmailVerificationController>();
    final userData = Get.arguments['data'];

    useEffect(() {
      controller.sendEmailVerification(showInfo: false);
      return null;
    }, []);

    Timer timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final user = controller.fetchUpdatedUser();
      bool isVerified = user?.emailVerified ?? false;
      if (isVerified) {
        timer.cancel();
        Get.back(result: userData);
      }
    });

    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: AppWidgets.appTextWithoutClick(
                  AppStrings.emailVerificationTitle,
                  fontSize: 15),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: AppWidgets.appTextWithoutClick(userData?.email ?? "",
                  fontSize: 15, isBold: true),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              child: AppWidgets.appTextWithoutClick(
                  AppStrings.emailVerificationMessage,
                  fontSize: 15),
            ),
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
            Container(
              alignment: Alignment.center,
              width: 150,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: AppWidgets.appButton(
                  AppStrings.resend, () => controller.sendEmailVerification()),
            )
          ],
        ),
      )),
    );
  }
}
