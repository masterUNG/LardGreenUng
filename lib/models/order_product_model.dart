// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProductModel {
  final String uidSeller;
  final String uidBuyer;
  final Timestamp timeOrder;
  final String status;
  final List<String> docIdProducts;
  final List<String> nameProducts;
  final List<String> priceProducts;
  final List<String> amountProducts;
  final List<String> sumProducts;
  final String total;
  OrderProductModel({
    required this.uidSeller,
    required this.uidBuyer,
    required this.timeOrder,
    required this.status,
    required this.docIdProducts,
    required this.nameProducts,
    required this.priceProducts,
    required this.amountProducts,
    required this.sumProducts,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidSeller': uidSeller,
      'uidBuyer': uidBuyer,
      'timeOrder': timeOrder,
      'status': status,
      'docIdProducts': docIdProducts,
      'nameProducts': nameProducts,
      'priceProducts': priceProducts,
      'amountProducts': amountProducts,
      'sumProducts': sumProducts,
      'total': total,
    };
  }

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      uidSeller: (map['uidSeller'] ?? '') as String,
      uidBuyer: (map['uidBuyer'] ?? '') as String,
      timeOrder: (map['timeOrder']),
      status: (map['status'] ?? '') as String,
      docIdProducts: List<String>.from(map['docIdProducts']),
      nameProducts: List<String>.from(map['nameProducts']),
      priceProducts: List<String>.from(map['priceProducts']),
      amountProducts: List<String>.from(map['amountProducts']),
      sumProducts: List<String>.from(map['sumProducts']),
      total: (map['total'] ?? '') as String,
    );
  }

  factory OrderProductModel.fromJson(String source) =>
      OrderProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}