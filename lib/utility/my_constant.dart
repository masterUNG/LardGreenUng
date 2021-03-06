import 'package:flutter/material.dart';

class MyConstant {
  static List<String> nameBanks = [
    'ธกส.',
    'กรุงเทพ',
    'กสิกร',
    'กรุงไทย',
    'ไทยพานิช',
  ];
  static List<String> svgBanks = [
    '/images/baac.svg',
    '/images/bbl.svg',
    '/images/kbank.svg',
    '/images/ktb.svg',
    '/images/scb.svg',
  ];

  static Color primary = const Color.fromARGB(255, 72, 185, 76);
  static Color dark = const Color.fromARGB(255, 13, 51, 87);
  static Color light = const Color.fromARGB(255, 136, 201, 138);

  static String routeMainHome = '/mainHome';
  static String routeHomePage = '/homePage';
  static String routeSellerService = '/sellerService';

  TextStyle h1Style() => TextStyle(
        color: dark,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3ActionStyle() => const TextStyle(
        color: Colors.pink,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

      TextStyle h2ActionStyle() => const TextStyle(
        color: Colors.pink,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      );
}
