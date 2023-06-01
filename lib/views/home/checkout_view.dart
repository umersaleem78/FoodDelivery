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
import 'package:food_app/views/home/order_success_view.dart';
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
              child: AppWidgets.appText(AppStrings.notLoggedInMessage,color: AppColors.textColor)),
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
              }, bgColor: AppColors.lightBlackColor))
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
        Get.offAll(() => const OrderSuccessView());
      }
    }

    return Scaffold(
        backgroundColor: AppColors.blackColor,
        body: SafeArea(
            child: isUserLoggedIn.value
                ? SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height + 50),
                      child: Column(
                        children: [
                          AppWidgets.appHeader(
                              AppStrings.checkout,
                              textColor: AppColors.textColor,
                              () => Get.back()),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(20),
                              child: AppWidgets.appTextWithoutClick(
                                  AppStrings.deliveryAddress,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor)),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.orangeColor),
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.lightWhiteColor,
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
                                          color: AppColors.textColor),
                                      AppWidgets.appTextWithoutClick(
                                          address.value,
                                          fontSize: 16,
                                          color: AppColors.lightWhiteColor,
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
                                    color: AppColors.orangeColor,
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
                                      color: AppColors.lightBlackColor),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.timer,
                                          color: AppColors.orangeColor,
                                          size: 50,
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          alignment: Alignment.center,
                                          child: AppWidgets.appTextWithoutClick(
                                              AppStrings.estimatedDeliveryTime,
                                              color: AppColors.textColor,
                                              fontSize: 13)),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          alignment: Alignment.center,
                                          child: AppWidgets.appTextWithoutClick(
                                              AppStrings.estimatedTime,
                                              color: AppColors.lightWhiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))
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
                                          color: AppColors.textColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.lightBlackColor),
                                      child: Row(children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                            Icons.money_rounded,
                                            size: 30,
                                            color: AppColors.orangeColor,
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
                                                      color:
                                                          AppColors.textColor,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 30,
                                            color: AppColors.orangeColor,
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
                                            color: AppColors.textColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
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
                                      alignment: Alignment.topCenter,
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
