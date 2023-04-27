// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/home/checkout_view.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../widgets/app_widgets.dart';

class CartView extends HookWidget {
  const CartView({super.key});

  Widget fetchCartItem(ItemsModel model, Function callback) {
    var description = model.description;
    if (model.quantity != "") {
      description = model.quantity;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 20, 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                width: 110,
                height: 110,
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: AppImages.imagePlaceholder,
                      image: model.image ?? "",
                      fit: BoxFit.contain,
                    )),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: AppWidgets.appText(model.name ?? "",
                              fontSize: 20, isBold: true)),
                      Container(
                          alignment: Alignment.topLeft,
                          child: AppWidgets.appText(description ?? "",
                              fontSize: 17)),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                child: AppWidgets.appText(
                                    "${model.currency} ${model.price}")),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: AppWidgets.fetchIncrementDecrementCounter(
                                  (number) {
                                if (number == 0) {
                                  CartState.removeItemFromCart(model);
                                } else {
                                  model.selectedQuantity = number;
                                  CartState.updateQuantity(model);
                                }
                                callback();
                              }, initialValue: model.selectedQuantity),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final updateData = useState(false);

    void updateCartData() {
      controller.cartItemsList.value = CartState.cartItemsList;
      controller.subTotal.value = CartState.fetchSubTotalAmount();
      controller.totalAmount.value = CartState.getTotalAmount();
    }

    useEffect(() {
      updateCartData();
      return null;
    }, [updateData]);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppWidgets.appHeader(AppStrings.cart, () => Get.back(),
                textColor: AppColors.primaryTextColor),
            Obx(
              () => Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: AppWidgets.appText(
                    "${AppStrings.totalItems}: (${controller.cartItemsList.value.length})",
                    isBold: true,
                    fontSize: 15),
              ),
            ),
            Obx(
              () => Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListView.builder(
                      itemCount: controller.cartItemsList.value.length,
                      itemBuilder: ((context, index) {
                        return fetchCartItem(
                            controller.cartItemsList.value[index], () {
                          updateData.value = !updateData.value;
                          updateCartData();
                        });
                      })),
                ),
              ),
            ),
            Obx(
              () => controller.cartItemsList.value.isNotEmpty
                  ? Card(
                      elevation: 5,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppWidgets.appText(AppStrings.subTotal,
                                    fontSize: 18),
                                Obx(
                                  () => AppWidgets.appText(
                                      controller.subTotal.value,
                                      fontSize: 18,
                                      isBold: true),
                                )
                              ],
                            ),
                            Divider(
                              color: AppColors.colorGrey,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppWidgets.appText(AppStrings.deliveryCharges,
                                    fontSize: 18),
                                AppWidgets.appText(
                                    CartState.getDeliveryCharges(),
                                    fontSize: 18,
                                    isBold: true)
                              ],
                            ),
                            Divider(
                              color: AppColors.colorGrey,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppWidgets.appText(AppStrings.tax,
                                    fontSize: 18),
                                AppWidgets.appText(CartState.getTax(),
                                    fontSize: 18, isBold: true)
                              ],
                            ),
                            Divider(
                              color: AppColors.colorGrey,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppWidgets.appText(AppStrings.totalAmount,
                                    fontSize: 18),
                                Obx(
                                  () => AppWidgets.appText(
                                      controller.totalAmount.value,
                                      fontSize: 18,
                                      isBold: true),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () =>
                                  GoNavigation.to(() => const CheckoutView()),
                              child: Container(
                                width: 120,
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.accentColor,
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppWidgets.appTextWithoutClick(
                                          AppStrings.checkout),
                                      const Icon(
                                        Icons.arrow_right,
                                        size: 25,
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
