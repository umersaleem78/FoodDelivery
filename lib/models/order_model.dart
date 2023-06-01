import 'package:food_app/models/items_model.dart';
import 'package:food_app/models/user_location_model.dart';
import 'package:food_app/models/user_model.dart';

class OrderModel {
  String? orderId;
  UserModel? userModel;
  UserLocationModel? userLocationModel;
  List<dynamic>? cartItems;
  String? userId;
  String? totalPrice;
  String? orderStatus;
  String? orderDate;
  String? orderTime;

  OrderModel(
      {this.orderId,
      this.userModel,
      this.userLocationModel,
      this.cartItems,
      this.userId,
      this.totalPrice,
      this.orderStatus,
      this.orderDate,
      this.orderTime});

  OrderModel.fromJson(Map<String, dynamic> json) {
    userModel = UserModel.fromJson(json['userModel']);
    userLocationModel = UserLocationModel.fromJson(json['userLocationModel']);
    cartItems = List.from(json['cartItems'])
        .map((e) => ItemsModel.fromJson(e))
        .toList();
    orderId = json['orderId'];
    userId = json['userId'];
    totalPrice = json['totalPrice'];
    orderStatus = json['orderStatus'];
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userModel'] = userModel?.toJson();
    data['orderId'] = orderId;
    data['userLocationModel'] = userLocationModel?.toJson();
    data['cartItems'] = cartItems?.map((e) => e?.toJson()).toList();
    data['userId'] = userId;
    data['totalPrice'] = totalPrice;
    data['orderStatus'] = orderStatus;
    data['orderDate'] = orderDate;
    data['orderTime'] = orderTime;
    return data;
  }
}
