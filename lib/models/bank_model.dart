import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BankModel {
  final String nameBank;
  final String nameAccountBank;
  final String accountBank;
  BankModel({
    required this.nameBank,
    required this.nameAccountBank,
    required this.accountBank,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameBank': nameBank,
      'nameAccountBank': nameAccountBank,
      'accountBank': accountBank,
    };
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      nameBank: (map['nameBank'] ?? '') as String,
      nameAccountBank: (map['nameAccountBank'] ?? '') as String,
      accountBank: (map['accountBank'] ?? '') as String,
    );
  }

  factory BankModel.fromJson(String source) => BankModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
