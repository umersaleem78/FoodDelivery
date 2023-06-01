import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/sign_up_controller.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_images.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/views/auth/email_verification_view.dart';
import 'package:food_app/views/auth/login_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../utils/go_navigation.dart';

class SignUpView extends HookWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void handleSignUpClick() async {
      final response = await controller.validateSignUpInput(
          nameController.text,
          emailController.text,
          passwordController.text,
          phoneController.text,
          () {});
      if (response != null && response is UserModel) {
        AppUtils.showToast(AppStrings.signUpSuccess);
        await controller.sendEmailVerification();
        final args = {'data': response};
        GoNavigation.off(() => const EmailVerificationView(), arguments: args);
      }
    }

    var showPassword = true.obs;
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
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Column(
                  children: [
                    AppWidgets.appFieldNew(AppStrings.name, nameController),
                    AppWidgets.appFieldNew(AppStrings.email, emailController),
                    AppWidgets.appFieldNewPhone(
                        AppStrings.phone, phoneController),
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: AppWidgets.appPassowrdField(AppStrings.password,
                            passwordController, showPassword.value, () {
                          showPassword.value = !showPassword.value;
                        }),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: AppWidgets.appButton(
                          AppStrings.signUp, () => handleSignUpClick()),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                      child: AppWidgets.appText(AppStrings.alreadyHaveAnAccount,
                          isClickable: true,
                          color: AppColors.textColor,
                          callBack: () =>
                              GoNavigation.off(() => const LoginView())),
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
