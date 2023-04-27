import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/local/local_storage.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/auth/login_view.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../widgets/app_widgets.dart';

class SettingsController extends GetxController {
  void confirmLogout(Function callback) {
    AppWidgets.openYesNoAlertDialog(AppStrings.logout, AppStrings.logoutConfirm,
        (res) {
      if (res) {
        AppState.clearAppState();
        LocalStorage.clearPrefs();
        CartState.clearCart();
        EasyLoading.showSuccess(AppStrings.logoutSuccess);
        callback();
      }
    });
  }

  void moveToLogin(Function callBack) {
    GoNavigation.to(() => const LoginView()).then((value) => callBack());
  }
}
