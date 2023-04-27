// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:food_app/models/items_model.dart';

class CategoriesModel {
  int? id;
  String? image;
  String? name;
  List<ItemsModel>? items;
  bool isSelected = false;
  CategoriesModel({
    this.id,
    this.image,
    this.name,
    this.items,
    this.isSelected = false,
  });

  CategoriesModel copyWith({
    int? id,
    String? image,
    String? name,
    List<ItemsModel>? items,
    bool isSelected = false,
  }) {
    return CategoriesModel(
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        items: items ?? this.items,
        isSelected: false);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
      'items': items?.map((x) => x.toMap()).toList(),
      'isSelected': isSelected
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> map) {
    return CategoriesModel(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      isSelected: false,
      items: map['items'] != null
          ? List<ItemsModel>.from(
              (map['items'] as List<dynamic>).map<ItemsModel?>(
                (x) => ItemsModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesModel.fromJson(String source) =>
      CategoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoriesModel(id: $id, image: $image, name: $name, items: $items, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant CategoriesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.image == image &&
        other.name == name &&
        other.isSelected == isSelected &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        isSelected.hashCode ^
        name.hashCode ^
        items.hashCode;
  }
}
