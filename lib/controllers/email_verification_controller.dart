import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  User? fetchUpdatedUser() {
    FirebaseAuth.instance.currentUser?.reload();
    return FirebaseAuth.instance.currentUser;
  }

  Future<dynamic> sendEmailVerification({bool showInfo = true}) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    if (showInfo) {
      EasyLoading.showInfo(AppStrings.verificationEmailSent);
    }
  }
}
