import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SlipModel {
  final String urlSlip;
  SlipModel({
    required this.urlSlip,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'urlSlip': urlSlip,
    };
  }

  factory SlipModel.fromMap(Map<String, dynamic> map) {
    return SlipModel(
      urlSlip: (map['urlSlip'] ?? '') as String,
    );
  }

  factory SlipModel.fromJson(String source) => SlipModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
