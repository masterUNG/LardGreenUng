import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModle {
  final String address;
  final String email;
  final String name;
  final String password;
  final String phone;
  final String status;
  final String token;
  final String typeUser;
  UserModle({
    required this.address,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.status,
    required this.token,
    required this.typeUser,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'status': status,
      'token': token,
      'typeUser': typeUser,
    };
  }

  factory UserModle.fromMap(Map<String, dynamic> map) {
    return UserModle(
      address: (map['address'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      status: (map['status'] ?? '') as String,
      token: (map['token'] ?? '') as String,
      typeUser: (map['typeUser'] ?? '') as String,
    );
  }

  factory UserModle.fromJson(String source) => UserModle.fromMap(json.decode(source) as Map<String, dynamic>);
}
