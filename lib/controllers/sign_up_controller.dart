import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/local/local_storage.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  SignUpController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> validateSignUpInput(
      name, email, password, phone, callback) async {
    var errorMessage = "";
    if (name == "") {
      errorMessage = AppStrings.enterName;
    } else if (email == "") {
      errorMessage = AppStrings.enterEmail;
    } else if (!GetUtils.isEmail(email)) {
      errorMessage = AppStrings.enterValidEmail;
    } else if (password == "") {
      errorMessage = AppStrings.enterPassword;
    } else if (phone == "" || phone.length < 10) {
      errorMessage = AppStrings.enterPhoneNumber;
    }

    if (errorMessage != '') {
      AppWidgets.appErrorView(Get.context, AppStrings.error, errorMessage);
      return null;
    }
    return handleSignUp(name, email, password, phone, callback);
  }

  Future<dynamic> handleSignUp(name, email, password, phone, callback) async {
    var errorMessage = "";
    UserModel? model;
    EasyLoading.show(status: AppStrings.loading);
    // handle sign up
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user != null) {
        model = UserModel(
            uid: user.uid, name: name, email: user.email, phoneNumber: phone);
        AppState.userModel = model;
        saveUserInfo(model);
        await firestoreInstance
            ?.collection(AppConstants.collectionUsers)
            .doc(model.uid)
            .set(model.toJson());
      } else {
        errorMessage = AppStrings.somethingWentWrong;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.weakPassword) {
        errorMessage = AppStrings.weakPassword;
      } else if (e.code == AppConstants.emailExists) {
        errorMessage = AppStrings.emailExists;
      }
    }
    EasyLoading.dismiss();
    if (errorMessage != "") {
      AppWidgets.appErrorView(Get.context, AppStrings.error, errorMessage);
      return null;
    }
    return model;
  }

  void saveUserInfo(UserModel model) async {
    await LocalStorage.storeData(AppConstants.userData, jsonEncode(model));
  }
}
