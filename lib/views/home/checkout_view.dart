import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/checkout_controller.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/home/dashboard_view.dart';
import 'package:food_app/views/home/location_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../auth/login_view.dart';
import '../auth/sign_up_view.dart';

class CheckoutView extends HookWidget {
  const CheckoutView({super.key});

  Widget fetchLoginAndSignUpView(Function callback) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: AppWidgets.appText(AppStrings.notLoggedInMessage)),
          AppWidgets.appButton(AppStrings.login, () async {
            var response = await GoNavigation.to(() => const LoginView());
            callback(response);
          }),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: AppWidgets.appButton(AppStrings.signUp, () async {
              var response = await GoNavigation.to(() => const SignUpView());
              callback(response);
            }),
          ),
          Container(
              width: 100,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: AppWidgets.appButton(AppStrings.close, () {
                Get.back();
              }, bgColor: AppColors.colorGrey))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final userData = AppState.userModel;
    var isUserLoggedIn = useState(false);
    late dynamic position;
    final address = useState('');

    TextEditingController nameController =
        TextEditingController(text: userData?.name);
    TextEditingController emailController =
        TextEditingController(text: userData?.email);
    TextEditingController phoneController =
        TextEditingController(text: userData?.phoneNumber);

    void checkLoginState() async {
      var userData = AppState.userModel;
      isUserLoggedIn.value = userData != null;
    }

    useEffect(() {
      final userLocation = AppState.userLocationModel;
      if (userLocation != null) {
        address.value = userLocation.address ?? "";
      }
      checkLoginState();
      return null;
    }, []);

    void updateAddress(value) {
      position = value["position"];
      address.value = value["address"];
      AppState.updateUserLocation(position, address.value);
    }

    void handlePlaceOrderClick() async {
      final response = await controller.validateInformation(
          nameController.text, emailController.text, phoneController.text);
      EasyLoading.showSuccess(AppStrings.orderPlacedSuccess);
      CartState.clearCart();
      if (response != null && response) {
        Get.offAll(() => const DashboardView());
      }
    }

    return Scaffold(
        body: SafeArea(
            child: isUserLoggedIn.value
                ? SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height + 50),
                      child: Column(
                        children: [
                          AppWidgets.appHeader(
                              AppStrings.checkout, () => Get.back()),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(20),
                              child: AppWidgets.appTextWithoutClick(
                                  AppStrings.delivery,
                                  isBold: true,
                                  fontSize: 25,
                                  color: AppColors.primaryDarkColor)),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.colorGrey),
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.accentColor,
                                  size: 25,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppWidgets.appTextWithoutClick(
                                          AppStrings.myLocation,
                                          fontSize: 12,
                                          color: AppColors.colorGrey),
                                      AppWidgets.appTextWithoutClick(
                                          address.value,
                                          fontSize: 16,
                                          color: AppColors.primaryTextColor,
                                          isBold: true)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: AppWidgets.appText(
                                    AppStrings.change,
                                    fontSize: 15,
                                    color: AppColors.primaryColor,
                                    isClickable: true,
                                    callBack: () => GoNavigation.to(
                                            () => const LocationView())
                                        .then((value) => updateAddress(value)),
                                  ))
                            ],
                          ),
                          address.value != ""
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.primaryLightColor),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.timer,
                                          color: AppColors.primaryDarkColor,
                                          size: 50,
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          alignment: Alignment.center,
                                          child: AppWidgets.appTextWithoutClick(
                                              AppStrings.estimatedDelivertTime,
                                              color: AppColors.offWhiteColor,
                                              fontSize: 13)),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          alignment: Alignment.center,
                                          child: AppWidgets.appTextWithoutClick(
                                              AppStrings.estimatedTime,
                                              color: AppColors.primaryDarkColor,
                                              fontSize: 16,
                                              isBold: true))
                                    ],
                                  ),
                                )
                              : Container(),
                          address.value != ""
                              ? Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 0),
                                      child: AppWidgets.appTextWithoutClick(
                                          AppStrings.paymentMethod,
                                          color: AppColors.primaryTextColor,
                                          fontSize: 20,
                                          isBold: true),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.dividerColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.offWhiteColor),
                                      child: Row(children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: const Icon(
                                            Icons.money_rounded,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: AppWidgets
                                                  .appTextWithoutClick(
                                                      AppStrings.cashOnDelivery,
                                                      fontSize: 15,
                                                      color: AppColors
                                                          .primaryTextColor,
                                                      isBold: true)),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 30,
                                            color: AppColors.primaryDarkColor,
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                )
                              : Container(),
                          address.value != ""
                              ? Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 15, 0, 5),
                                        alignment: Alignment.topLeft,
                                        child: AppWidgets.appTextWithoutClick(
                                            AppStrings.details,
                                            fontSize: 20,
                                            isBold: true)),
                                    AppWidgets.appFieldNew(
                                        AppStrings.name, nameController),
                                    AppWidgets.appFieldNew(
                                        AppStrings.email, emailController),
                                    AppWidgets.appFieldNewPhone(
                                        AppStrings.phone, phoneController)
                                  ],
                                )
                              : Container(),
                          address.value != ""
                              ? Flexible(
                                  child: Container(
                                      alignment: Alignment.bottomRight,
                                      margin: const EdgeInsets.all(20),
                                      child: AppWidgets.appButton(
                                          AppStrings.placeOrder,
                                          () => handlePlaceOrderClick())),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : fetchLoginAndSignUpView((data) {
                    checkLoginState();
                  })));
  }
}
