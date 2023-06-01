import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_images.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/auth/email_verification_view.dart';
import 'package:food_app/views/auth/sign_up_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var showPassword = true.obs;

    void handleLoginClick() async {
      final response = await controller.validateLoginInput(
          emailController.text, passwordController.text, () {});
      if (response != null && response is UserModel) {
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified == true) {
          EasyLoading.showSuccess(AppStrings.loginSuccess);
          Get.back(result: response);
        } else {
          final args = {'data': response};
          GoNavigation.off(() => const EmailVerificationView(),
              arguments: args);
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 65, 0, 0),
                child: Image.asset(
                  AppImages.appLogo,
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: AppWidgets.appFieldNew(
                            AppStrings.email, emailController,
                            inputType: TextInputType.emailAddress)),
                    Obx(
                      () => Container(
                        child: AppWidgets.appPassowrdField(AppStrings.password,
                            passwordController, showPassword.value, () {
                          showPassword.value = !showPassword.value;
                        }),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: AppWidgets.appButton(
                          AppStrings.login, () => handleLoginClick()),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                      child: AppWidgets.appText(AppStrings.noAccountSignUp,color: AppColors.textColor,
                          isClickable: true,
                          callBack: () =>
                              GoNavigation.off(() => const SignUpView())),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
