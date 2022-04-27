// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreenung/widgets/show_title.dart';

class OrderSeller extends StatelessWidget {
  final String docIdUser;
  const OrderSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowTitle(title: 'รายการสั่งซื่อ');
  }
}
