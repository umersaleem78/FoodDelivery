import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/location_controller.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationView extends HookWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final locationTFController = TextEditingController();
    final controller = Get.find<LocationController>();
    late dynamic position;

    void requestLocation() async {
      try {
        position = await controller.fetchUserLocation();
        if (position is Position) {
          final currentAddress = await controller.fetchAddressFromCoordinates(
              position.latitude, position.longitude);
          if (currentAddress != null) {
            locationTFController.text = currentAddress;
          }
        }
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    }

    useEffect(() {
      requestLocation();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: Column(
        children: [
          AppWidgets.appHeader(AppStrings.selectLocation, () => Get.back()),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: AppWidgets.appFieldNew(
                  AppStrings.location, locationTFController)),
          Container(
              margin: const EdgeInsets.all(20),
              child: AppWidgets.appButton(AppStrings.updateLocation, () {
                final arguments = {
                  "position": position,
                  "address": locationTFController.text
                };
                Get.back(result: arguments);
              })),
        ],
      )),
    );
  }
}
