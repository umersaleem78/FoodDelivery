// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'items_model.g.dart';

@collection
class ItemsModel {
  Id modelId = Isar.autoIncrement;
  String? currency;
  String? image;
  String? name;
  int? price;
  String? quantity;
  int? selectedQuantity;
  String? id;
  String? coverImage;
  String? description;
  String? calories;
  int? preparationTime;
  double? rating;

  ItemsModel(
      this.currency,
      this.image,
      this.name,
      this.price,
      this.quantity,
      this.selectedQuantity,
      this.id,
      this.coverImage,
      this.description,
      this.calories,
      this.preparationTime,
      this.rating);

  ItemsModel copyWith(
      {String? currency,
      String? image,
      String? name,
      int? price,
      String? quantity,
      int? selectedQuantity,
      String? id,
      String? coverImage,
      String? description,
      String? calories,
      int? preparationTime,
      double? rating}) {
    return ItemsModel(
        currency ?? this.currency,
        image ?? this.image,
        name ?? this.name,
        price ?? this.price,
        quantity ?? this.quantity,
        selectedQuantity ?? this.selectedQuantity,
        id ?? this.id,
        coverImage ?? this.coverImage,
        description ?? this.description,
        calories ?? this.calories,
        preparationTime ?? this.preparationTime,
        rating ?? this.rating);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'image': image,
      'name': name,
      'price': price,
      'quantity': quantity,
      'selectedQuantity': selectedQuantity,
      'id': id,
      'coverImage': coverImage,
      'description': description,
      'calories': calories,
      'preparationTime': preparationTime,
      'rating': rating
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
        map['currency'] != null ? map['currency'] as String : null,
        map['image'] != null ? map['image'] as String : null,
        map['name'] != null ? map['name'] as String : null,
        map['price'] != null ? map['price'] as int : null,
        map['quantity'] != null ? map['quantity'] as String : null,
        map['selectedQuantity'] != null ? map['selectedQuantity'] as int : null,
        map['id'] != null ? map['id'] as String : null,
        map['coverImage'] != null ? map['coverImage'] as String : null,
        map['description'] != null ? map['description'] as String : null,
        map['calories'] != null ? map['calories'] as String : null,
        map['preparationTime'] != null ? map['preparationTime'] as int : null,
        map['rating'] != null ? map['rating'] as double : null);
  }

  String toJson() => json.encode(toMap());

  factory ItemsModel.fromJson(String source) =>
      ItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemsModel(currency: $currency, image: $image, name: $name, price: $price, quantity: $quantity, id: $id, coverImage: $coverImage, description : $description)';
  }

  @override
  bool operator ==(covariant ItemsModel other) {
    if (identical(this, other)) return true;

    return other.currency == currency &&
        other.image == image &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.selectedQuantity == selectedQuantity &&
        other.coverImage == coverImage &&
        other.description == description &&
        other.id == id;
  }

  @override
  int get hashCode {
    return currency.hashCode ^
        image.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        coverImage.hashCode ^
        description.hashCode ^
        id.hashCode;
  }
}
