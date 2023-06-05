import '../utils/app_strings.dart';

class CancelOrderModel {
  String name = "";
  bool isSelected = false;

  CancelOrderModel({required this.name, required this.isSelected});

  List<CancelOrderModel> fetchCancelOrdersList() {
    List<CancelOrderModel> list = [];
    list.add(CancelOrderModel(
        name: AppStrings.waitingForLongTime, isSelected: false));
    list.add(CancelOrderModel(
        name: AppStrings.unableToContactRider, isSelected: false));
    list.add(CancelOrderModel(
        name: AppStrings.wrongAddressShown, isSelected: false));
    list.add(CancelOrderModel(
        name: AppStrings.priceNotReasonable, isSelected: false));
    list.add(CancelOrderModel(name: AppStrings.justCancel, isSelected: false));
    return list;
  }
}
