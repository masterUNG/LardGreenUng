// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String detail;
  final String name;
  final int price;
  final String status;
  final int stock;
  final Timestamp timeAdd;
  final String unit;
  final String urlProduct;
  ProductModel({
    required this.detail,
    required this.name,
    required this.price,
    required this.status,
    required this.stock,
    required this.timeAdd,
    required this.unit,
    required this.urlProduct,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'detail': detail,
      'name': name,
      'price': price,
      'status': status,
      'stock': stock,
      'timeAdd': timeAdd,
      'unit': unit,
      'urlProduct': urlProduct,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      detail: (map['detail'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      price: (map['price'] ?? 0) as int,
      status: (map['status'] ?? '') as String,
      stock: (map['stock'] ?? 0) as int,
      timeAdd: (map['timeAdd']),
      unit: (map['unit'] ?? '') as String,
      urlProduct: (map['urlProduct'] ?? '') as String,
    );
  }

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
