import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/cancel_order_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/checkout_controller.dart';
import 'package:food_app/controllers/email_verification_controller.dart';
import 'package:food_app/controllers/favourites_controller.dart';
import 'package:food_app/controllers/home_controller.dart';
import 'package:food_app/controllers/location_controller.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/controllers/order_track_controller.dart';
import 'package:food_app/controllers/orders_controller.dart';
import 'package:food_app/controllers/products_controller.dart';
import 'package:food_app/controllers/settings_controller.dart';
import 'package:food_app/controllers/sign_up_controller.dart';
import 'package:food_app/local/isar_operations.dart';
import 'package:food_app/local/prefs.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/views/splash_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:isar/isar.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/app_constants.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Prefs.initializePrefs();
  final dir = await getApplicationDocumentsDirectory();
  IsarOperations.isar = await Isar.open(
    [ItemsModelSchema],
    directory: dir.path,
  );
  // load user model data if exists
  var userData = Prefs.fetchData(AppConstants.userData);
  if (userData != null) {
    AppState.userModel = UserModel.fromJson(jsonDecode(userData));
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(SignUpController());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(ProductsController());
  Get.put(CartController());
  Get.put(LocationController());
  Get.put(CheckoutController());
  Get.put(SettingsController());
  Get.put(OrdersController());
  Get.put(EmailVerificationController());
  Get.put(OrderTrackController());
  Get.put(FavouritesController());
  Get.put(CancelOrderController());
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ));
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food App',
        theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: const Color(0xFFFE724C).toMaterialColor()),
        home: const SplashView(),
        builder: EasyLoading.init());
  }
}
