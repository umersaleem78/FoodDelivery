import 'package:food_app/models/user_location_model.dart';
import 'package:food_app/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

class AppState {
  static UserModel? userModel;
  static UserLocationModel? userLocationModel;

  static void updateUserLocation(Position position, String address) {
    userLocationModel ??= UserLocationModel();
    userLocationModel?.latitude = position.latitude;
    userLocationModel?.longitude = position.longitude;
    userLocationModel?.address = address;
  }

  static void clearAppState() {
    userModel = null;
    userLocationModel = null;
  }
}
