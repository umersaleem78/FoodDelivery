import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/views/home/favourite_view.dart';
import 'package:food_app/views/home/home_view.dart';
import 'package:food_app/views/home/orders_view.dart';
import 'package:food_app/views/home/settings_view.dart';

class DashboardView extends HookWidget {
  const DashboardView({super.key});
  /*IndexedStack(
        index: selectedIndex.value,
        children: _pages,
      ) */

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const <Widget>[
      HomeView(),
      FavouriteView(),
      OrdersView(),
      SettingsView(),
    ];
    final selectedIndex = useState(0);

    PageController pageController =
        PageController(initialPage: selectedIndex.value);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.lightBlackColor,
        unselectedItemColor: AppColors.lightWhiteColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_filled), label: AppStrings.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite), label: AppStrings.favourite),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag), label: AppStrings.orders),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings), label: AppStrings.settings)
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
          pageController.jumpToPage(selectedIndex.value);
        },
      ),
    );
  }
}
