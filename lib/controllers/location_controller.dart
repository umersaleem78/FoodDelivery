import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  Future<dynamic> fetchUserLocation() async {
    EasyLoading.show(status: AppStrings.fetchingLocation);
    // check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.dismiss();
      return Future.error(AppStrings.locationServicesDisabled);
    }
    // check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      EasyLoading.dismiss();
      permission = await Geolocator.requestPermission();
      EasyLoading.show(status: AppStrings.fetchingLocation);
      // check location permission again after requesting permission
      if (permission == LocationPermission.denied) {
        EasyLoading.dismiss();
        return Future.error(AppStrings.locationPermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      EasyLoading.dismiss();
      return Future.error(AppStrings.locationPermissionPermanentlyDenied);
    }

    return await Geolocator.getCurrentPosition();
  }
}
