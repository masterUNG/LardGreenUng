import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQliteModel {
  final int? id;
  final String docIdSeller;
  final String nameSeller;
  final String docIdProduct;
  final String nameProduct;
  final String price;
  final String amount;
  final String sum;
  SQliteModel({
    this.id,
    required this.docIdSeller,
    required this.nameSeller,
    required this.docIdProduct,
    required this.nameProduct,
    required this.price,
    required this.amount,
    required this.sum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docIdSeller': docIdSeller,
      'nameSeller': nameSeller,
      'docIdProduct': docIdProduct,
      'nameProduct': nameProduct,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQliteModel.fromMap(Map<String, dynamic> map) {
    return SQliteModel(
      id: map['id'] != null ? map['id'] as int : null,
      docIdSeller: (map['docIdSeller'] ?? '') as String,
      nameSeller: (map['nameSeller'] ?? '') as String,
      docIdProduct: (map['docIdProduct'] ?? '') as String,
      nameProduct: (map['nameProduct'] ?? '') as String,
      price: (map['price'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      sum: (map['sum'] ?? '') as String,
    );
  }

  factory SQliteModel.fromJson(String source) => SQliteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
