// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:badges/badges.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/home_controller.dart';
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
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/categories_model.dart';
import '../../models/items_model.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  Widget fetchCategoryItem(
      CategoriesModel model, Function callback, selectedId) {
    return InkWell(
      onTap: () => callback(model.id),
      child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: AppWidgets.appTextWithoutClick(model.name ?? "",
              color: model.isSelected
                  ? AppColors.primaryTextColor
                  : AppColors.secondaryTextColor,
              fontSize: 18,
              isBold: model.isSelected ? true : false)),
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

  Widget fetchBannerView(data) {
    final bannerModel = BannersModel.fromJson(data);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: AppImages.imagePlaceholder,
                image: bannerModel.image ?? "",
                fit: BoxFit.fill,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final totalCartItems = useState(0);
    final updateItemsList = false.obs;
    final currentSelectedCategoryIndex = useState(-1);
    var currentBannerIndex = useState(0);

    // ignore: unused_local_variable
    Timer timer;
    PageController pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.88,
    );

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

    void startBannerTimer() {
      // auto scroll page view banners
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        final totalBanners = controller.bannersList.length - 1;
        if (currentBannerIndex.value < totalBanners) {
          currentBannerIndex.value++;
        } else {
          currentBannerIndex.value = 0;
        }
        print('Page Controller => ${pageController.hasClients}');
        if (pageController.hasClients) {
          pageController.animateToPage(currentBannerIndex.value,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeIn);
        }
      });
    }

    useEffect(() {
      // load banners
      if (controller.bannersList.isEmpty) {
        controller.fetchBannerInfo();
      }

      if (controller.categoriesList.isEmpty) {
        controller.fetchCategories().then((value) {
          currentSelectedCategoryIndex.value = 0;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //startBannerTimer();
      });
      return null;
    }, []);

    void updateSelectedCategoryItem(item) {
      final previousSelectedIndex = controller.categoriesList
          .indexWhere((element) => element.isSelected == true);
      controller.categoriesList.value[previousSelectedIndex].isSelected = false;
      final newSelectedIndex = controller.categoriesList.value.indexOf(item);
      currentSelectedCategoryIndex.value = newSelectedIndex;
      controller.categoriesList.value[newSelectedIndex].isSelected = true;
    }

    return VisibilityDetector(
      key: const Key('my-widget-key'),
      onVisibilityChanged: (info) =>
          updateBasketNumber(updateCategorySelection: true),
      child: Scaffold(
        backgroundColor: AppColors.offWhiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => GoNavigation.to(() => const ProfileView()),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(AppImages.profilePlaceholder),
                        radius: 25,
                      ),
                    ),
                    totalCartItems.value > 0
                        ? InkWell(
                            onTap: () =>
                                GoNavigation.to(() => const CartView()),
                            child: badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                  badgeColor: AppColors.primaryLightColor,
                                  shape: BadgeShape.circle),
                              badgeContent: Text(
                                  totalCartItems.value.toString(),
                                  style: const TextStyle(color: Colors.white)),
                              child: Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                  height: 200,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Swiper(
                    itemBuilder: ((context, index) {
                      return fetchBannerView(
                          controller.bannersList.value[index]);
                    }),
                    itemCount: controller.bannersList.value.length,
                    onIndexChanged: ((value) =>
                        currentBannerIndex.value = value),
                    autoplay: true,
                    viewportFraction: 0.88,
                    autoplayDelay: 7000,
                    autoplayDisableOnInteraction: false,
                  )),
              Obx(() => controller.bannersList.value.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: DotsIndicator(
                        dotsCount: controller.bannersList.value.length,
                        position: currentBannerIndex.value.toDouble(),
                        decorator:
                            DotsDecorator(color: AppColors.primaryLightColor),
                      ),
                    )
                  : Container()),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                alignment: Alignment.topLeft,
                child: AppWidgets.appText(AppStrings.categories,
                    fontSize: 15,
                    isBold: true,
                    color: AppColors.primaryTextColor),
              ),
              Obx(
                () => Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 30,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categoriesList.value.length,
                      itemBuilder: ((context, index) {
                        return fetchCategoryItem(
                          controller.categoriesList.value[index],
                          (id) => updateSelectedCategoryItem(
                              controller.categoriesList.value[index]),
                          currentSelectedCategoryIndex.value,
                        );
                      })),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: AppWidgets.appText(AppStrings.products,
                    fontSize: 20,
                    isBold: true,
                    color: AppColors.primaryTextColor),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: (.32 / .4)),
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
                          () => fetchItemView(item, () => updateCartView(),
                              updateItemsList.value),
                        );
                      })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
