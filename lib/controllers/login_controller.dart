import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/constants/app_constants.dart';
import 'package:food_app/local/prefs.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseFirestore? firestoreInstance;

  LoginController() {
    firestoreInstance ??= FirebaseFirestore.instance;
  }

  Future<dynamic> validateLoginInput(email, password, callback) async {
    if (email == "") {
      EasyLoading.showError(AppStrings.enterEmail);
      return;
    } else if (!GetUtils.isEmail(email)) {
      EasyLoading.showError(AppStrings.enterValidEmail);
      return;
    } else if (password == "") {
      EasyLoading.showError(AppStrings.enterPassword);
      return;
    }
    return handleLogin(email, password, callback);
  }

  Future<dynamic> handleLogin(email, password, callback) async {
    EasyLoading.show(status: AppStrings.loading);
    // handle sign up
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      log(user?.uid.toString() ?? "");
      if (user != null) {
        final response = await firestoreInstance
            ?.collection(AppConstants.collectionUsers)
            .doc(user.uid)
            .get();
        final data = response?.data();
        EasyLoading.dismiss();

        if (data != null) {
          var model = UserModel.fromJson(data);
          AppState.userModel = model;
          saveUserInfo(model);
          return model;
        }
      } else {
        showError(AppStrings.somethingWentWrong);
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.wrongPassword) {
        showError(AppStrings.wrongPassword);
      } else if (e.code == AppConstants.userNotFound) {
        showError(AppStrings.noUserFound);
      }
    }
    return null;
  }

  void showError(String message) {
    EasyLoading.dismiss();
    EasyLoading.showError(message);
  }

  void saveUserInfo(UserModel model) async {
    await Prefs.storeData(AppConstants.userData, jsonEncode(model));
  }
}
