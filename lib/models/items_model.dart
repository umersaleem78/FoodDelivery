// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemsModel {
  String? currency;
  String? image;
  String? name;
  int? price;
  String? quantity;
  int? selectedQuantity;
  String? id;
  String? coverImage;
  String? description;

  ItemsModel(
      {this.currency,
      this.image,
      this.name,
      this.price,
      this.quantity,
      this.selectedQuantity,
      this.id,
      this.coverImage,
      this.description});

  ItemsModel copyWith(
      {String? currency,
      String? image,
      String? name,
      int? price,
      String? quantity,
      int? selectedQuantity,
      String? id,
      String? coverImage,
      String? description}) {
    return ItemsModel(
        currency: currency ?? this.currency,
        image: image ?? this.image,
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        selectedQuantity: selectedQuantity ?? this.selectedQuantity,
        id: id ?? this.id,
        coverImage: coverImage ?? this.coverImage,
        description: description ?? this.description);
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
      'description': description
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
        currency: map['currency'] != null ? map['currency'] as String : null,
        image: map['image'] != null ? map['image'] as String : null,
        name: map['name'] != null ? map['name'] as String : null,
        price: map['price'] != null ? map['price'] as int : null,
        quantity: map['quantity'] != null ? map['quantity'] as String : null,
        selectedQuantity: map['selectedQuantity'] != null
            ? map['selectedQuantity'] as int
            : null,
        id: map['id'] != null ? map['id'] as String : null,
        coverImage:
            map['coverImage'] != null ? map['coverImage'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null);
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
