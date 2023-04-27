// ignore_for_file: invalid_use_of_protected_member

import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/products_controller.dart';
import 'package:food_app/models/categories_model.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/views/home/product_detail_view.dart';
import 'package:get/get.dart';

import '../../models/items_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/go_navigation.dart';
import '../../widgets/app_widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'cart_view.dart';

class CategoriesView extends HookWidget {
  const CategoriesView({super.key});

  Widget fetchCategoryItem(
      CategoriesModel model, Function callback, selectedId) {
    return InkWell(
      onTap: () => callback(model.id),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: model.isSelected ? 3 : 0, color: AppColors.accentColor),
        ),
        width: 150,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: AppImages.imagePlaceholder,
                    image: model.image ?? "",
                    fit: BoxFit.fill,
                  )),
            ),
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade600.withOpacity(0.45)),
                    child: AppWidgets.appText(model.name ?? "",
                        color: AppColors.offWhiteColor,
                        fontSize: 20,
                        isBold: true),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget fetchItemView(ItemsModel model, Function callback, bool state) {
    final isItemInCart = CartState.isItemInCart(model).obs;
    final selectedQuantity = isItemInCart.value
        ? CartState.getItemQuantity(model)
        : model.selectedQuantity;
    return InkWell(
      onTap: () {
        final args = {'data': model};
        GoNavigation.to(() => const ProductDetailView(), arguments: args)
            .then((value) {
          isItemInCart.value = CartState.isItemInCart(model);
          callback();
        });
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.offWhiteColor,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                height: 70,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: AppImages.imagePlaceholder,
                      image: model.image ?? "",
                      fit: BoxFit.contain,
                    )),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: AppWidgets.appText(model.name ?? "",
                    fontSize: 15, isBold: true, isEllipsisText: true),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: AppWidgets.appText(model.quantity ?? "", fontSize: 12),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: AppWidgets.appText(
                    "${model.currency ?? ""} ${model.price?.toString() ?? ""}",
                    fontSize: 12),
              ),
              Obx(
                () => isItemInCart.value
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        alignment: Alignment.center,
                        child:
                            AppWidgets.fetchIncrementDecrementCounter((number) {
                          if (number == 0) {
                            CartState.removeItemFromCart(model,
                                showSnackbar: true);
                            isItemInCart.value = CartState.isItemInCart(model);
                          } else {
                            model.selectedQuantity = number;
                            CartState.updateQuantity(model);
                          }
                          callback();
                        }, initialValue: selectedQuantity),
                      )
                    : Container(
                        alignment: Alignment.bottomRight,
                        child: AppWidgets.addIconButton(() {
                          CartState.addItemInCart(model, () {
                            isItemInCart.value = CartState.isItemInCart(model);
                          });
                          isItemInCart.value = CartState.isItemInCart(model);
                          callback();
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final currentSelectedCategoryId = useState(-1);
    final updateItemsList = false.obs;
    final itemsList = useState([]);
    final totalCartItems = "0".obs;

    void updateBasketNumber() {
      totalCartItems.value = CartState.cartItemsList.length.toString();
    }

    // update cart view
    void updateCartView() {
      updateBasketNumber();
      updateItemsList.value = !updateItemsList.value;
    }

    useEffect(() {
      controller.fetchCategories().then((list) {
        if (list.isNotEmpty) {
          controller.categoriesList[0].isSelected = true;
          currentSelectedCategoryId.value = controller.categoriesList[0].id;
          itemsList.value = controller.categoriesList[0].items;
          // set all other items to false
          for (var item in controller.categoriesList.value) {
            if (item.id != currentSelectedCategoryId.value) {
              item.isSelected = false;
            }
          }
        }
      });
      updateBasketNumber();
      return null;
    }, []);

    void updateSelectedItem(id) {
      var newId = -1;
      var items = [];
      for (var item in controller.categoriesList.value) {
        if (id == item.id) {
          // if same item is not clicked then update it's value
          if (!item.isSelected) {
            item.isSelected = true;
            newId = item.id;
            items.addAll(item.items);
          }
        } else {
          item.isSelected = false;
        }
      }
      if (newId != -1) {
        currentSelectedCategoryId.value = newId;
        itemsList.value = items;
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Obx(
            () => int.parse(totalCartItems.value) > 0
                ? InkWell(
                    onTap: () => GoNavigation.to(() => const CartView())
                        .then((value) => updateCartView()),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      alignment: Alignment.bottomRight,
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                            badgeColor: AppColors.primaryColor,
                            shape: BadgeShape.circle),
                        badgeContent: Obx(
                          () => Text(totalCartItems.value,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: AppColors.primaryLightColor,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(20),
                    height: 10,
                  ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
            alignment: Alignment.topLeft,
            child: AppWidgets.appTextWithoutClick(AppStrings.categories,
                color: AppColors.primaryTextColor, fontSize: 30, isBold: true),
          ),
          Obx(
            () => Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categoriesList.value.length,
                  itemBuilder: ((context, index) {
                    return fetchCategoryItem(
                      controller.categoriesList.value[index],
                      (id) => updateSelectedItem(id),
                      currentSelectedCategoryId.value,
                    );
                  })),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: AppWidgets.appText(AppStrings.products,
                fontSize: 20, isBold: true),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: (.35 / .4)),
                  itemCount: itemsList.value.length,
                  itemBuilder: ((context, index) {
                    return Obx(
                      () => fetchItemView(itemsList.value[index],
                          () => updateCartView(), updateItemsList.value),
                    );
                  })),
            ),
          ),
        ],
      )),
    );
  }
}
