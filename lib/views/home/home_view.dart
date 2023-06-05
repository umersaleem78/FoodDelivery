// ignore_for_file: invalid_use_of_protected_member

import 'package:badges/badges.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/home_controller.dart';
import 'package:food_app/local/isar_operations.dart';
import 'package:food_app/models/banners_model.dart';
import 'package:food_app/state/cart_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_images.dart';
import 'package:badges/badges.dart' as badges;
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/home/cart_view.dart';
import 'package:food_app/views/home/product_detail_view.dart';
import 'package:food_app/views/home/profile_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

import '../../models/categories_model.dart';
import '../../models/items_model.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  Widget fetchBannerItem(BannersModel model) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: AppImages.imagePlaceholder,
                image: model.image ?? "",
                fit: BoxFit.fill,
              )),
        ],
      ),
    );
  }

  Widget fetchCategoryItem(
      CategoriesModel model, Function callback, selectedId) {
    return InkWell(
      onTap: () => callback(model.id),
      child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: FadeInImage.assetNetwork(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn,
                    placeholder: AppImages.imagePlaceholder,
                    image: model.image ?? ""),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: AppWidgets.appTextWithoutClick(model.name ?? "",
                    color: model.isSelected
                        ? AppColors.orangeColor
                        : AppColors.textColor,
                    fontSize: 12,
                    fontWeight:
                        model.isSelected ? FontWeight.w600 : FontWeight.w300),
              ),
            ],
          )),
    );
  }

  Widget fetchProductItem(ItemsModel model, Function callback, bool state) {
    final isItemInCart = CartState.isItemInCart(model).obs;
    final selectedQuantity = isItemInCart.value
        ? CartState.getItemQuantity(model)
        : model.selectedQuantity;
    var isAlreadyFavourite = false.obs;
    IsarOperations.checkItemExists(model).then((value) {
      isAlreadyFavourite.value = value;
    });
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
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.lightBlackColor,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                height: 70,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      model.image ?? "",
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: AppWidgets.appTextWithoutClick(model.name ?? "",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    isEllipsisText: true,
                    color: AppColors.textColor),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    IsarOperations.handleFavouriteItemClick(model, (isRemoved) {
                      callback();
                    });
                  },
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.favorite,
                        color: isAlreadyFavourite.value
                            ? AppColors.statusColorPending
                            : AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: AppWidgets.appTextWithoutClick(
                          "${model.currency ?? ""} ${model.price?.toString() ?? ""}",
                          fontSize: 12,
                          color: AppColors.lightWhiteColor),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppWidgets.appTextWithoutClick(
                          model.quantity ?? "",
                          fontSize: 12,
                          color: AppColors.lightWhiteColor),
                    ),
                  ],
                ),
              ),
              Obx(
                () => isItemInCart.value
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        alignment: Alignment.bottomRight,
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
    final controller = Get.find<HomeController>();
    final currentBannerIndex = useState(0);
    final bannersList = useState([]);
    final categoriesList = useState([]);
    final totalCartItems = useState(0);
    final updateItemsList = useState(false);
    final currentSelectedCategoryIndex = useState(-1);

    useEffect(() {
      // load banners
      controller.fetchBannerInfo().then((value) {
        bannersList.value = value;
      });

      controller.fetchCategories().then((value) {
        categoriesList.value = value;
        currentSelectedCategoryIndex.value = 0;
      });
      return null;
    }, [null]);

    void updateBasketNumber({bool updateCategorySelection = false}) {
      totalCartItems.value = CartState.cartItemsList.length;
      if (updateCategorySelection &&
          controller.categoriesList.value.isNotEmpty) {
        final selectectedIndex = controller.getCurrentSelectedCategory();
        currentSelectedCategoryIndex.value = selectectedIndex;
      }
    }

    // update cart view
    void updateCartView() {
      updateBasketNumber();
      updateItemsList.value = !updateItemsList.value;
    }

    void updateSelectedCategoryItem(item) {
      final previousSelectedIndex = controller.categoriesList
          .indexWhere((element) => element.isSelected == true);
      controller.categoriesList.value[previousSelectedIndex].isSelected = false;
      final newSelectedIndex = controller.categoriesList.value.indexOf(item);
      currentSelectedCategoryIndex.value = newSelectedIndex;
      controller.categoriesList.value[newSelectedIndex].isSelected = true;
    }

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
              child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => GoNavigation.to(() => const ProfileView()),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(AppImages.profilePlaceholder),
                        radius: 20,
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          GoNavigation.to(() => const CartView()).then((value) {
                        updateBasketNumber();
                      }),
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                            badgeColor: AppColors.orangeColor,
                            shape: BadgeShape.circle),
                        badgeContent: Text(totalCartItems.value.toString(),
                            style: const TextStyle(color: Colors.white)),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: AppColors.lightWhiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: 175,
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: PageView.builder(
                    onPageChanged: (value) => currentBannerIndex.value = value,
                    itemCount: bannersList.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = bannersList.value[index];
                      return fetchBannerItem(item);
                    },
                  )),
              bannersList.value.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: DotsIndicator(
                        dotsCount: bannersList.value.length,
                        position: currentBannerIndex.value.toDouble(),
                        decorator:
                            DotsDecorator(color: AppColors.lightWhiteColor),
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                alignment: Alignment.topLeft,
                child: AppWidgets.appText(AppStrings.categories,
                    fontSize: 15,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categoriesList.value.length,
                    itemBuilder: ((context, index) {
                      final item = controller.categoriesList.value[index];
                      return fetchCategoryItem(
                        item,
                        (id) => updateSelectedCategoryItem(item),
                        currentSelectedCategoryIndex.value,
                      );
                    })),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                child: AppWidgets.appText(AppStrings.products,
                    fontSize: 15,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: (.30 / .4)),
                      itemCount: currentSelectedCategoryIndex.value == -1
                          ? 0
                          : controller
                              .categoriesList[
                                  currentSelectedCategoryIndex.value]
                              .items
                              .length,
                      itemBuilder: ((context, index) {
                        final item = controller
                            .categoriesList[currentSelectedCategoryIndex.value]
                            .items[index];
                        return Obx(
                          () => fetchProductItem(item, () => updateCartView(),
                              updateItemsList.value),
                        );
                      })),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
