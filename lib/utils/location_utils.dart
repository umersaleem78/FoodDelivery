import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';

import 'app_strings.dart';

class LocationUtils {
  static Future<dynamic> fetchAddressFromCoordinates(
      double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return "";
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      EasyLoading.dismiss();
      return "${place.name}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    }
    EasyLoading.dismiss();
    return Future.error(AppStrings.noLocationFound);
  }

  static Future<dynamic> fetchSubLocalityFromCoordinates(
      double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return "";
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      EasyLoading.dismiss();
      return place.subLocality;
    }
    EasyLoading.dismiss();
    return Future.error(AppStrings.noLocationFound);
  }
}
