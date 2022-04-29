// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/utility/my_calculate.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';

import 'package:lardgreenung/widgets/show_title.dart';

class OrderSeller extends StatefulWidget {
  final String docIdUser;
  const OrderSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<OrderSeller> createState() => _OrderSellerState();
}

class _OrderSellerState extends State<OrderSeller> {
  bool load = true;
  bool? haveOrder;
  var orderProductModels = <OrderProductModel>[];

  @override
  void initState() {
    super.initState();
    readMyOrder();
  }

  Future<void> readMyOrder() async {
    if (orderProductModels.isNotEmpty) {
      orderProductModels.clear();
    }

    var user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    await FirebaseFirestore.instance
        .collection('order')
        .where('uidSeller', isEqualTo: uid)
        .get()
        .then((value) {
      load = false;
      if (value.docs.isEmpty) {
        haveOrder = false;
      } else {
        haveOrder = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? const ShowTitle(title: 'รายการสั่งซื่อ')
            : Center(
                child: ShowText(
                lable: 'ไม่มีรายการ สั่งซื้อ',
                textStyle: MyConstant().h1Style(),
              ));
  }
}
