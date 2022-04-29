// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/models/user_model.dart';
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
  var userModels = <UserModle>[];
  List<List<Widget>> listWidget = [];

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
        .then((value) async {
      load = false;
      if (value.docs.isEmpty) {
        haveOrder = false;
      } else {
        haveOrder = true;

        for (var item in value.docs) {
          OrderProductModel model = OrderProductModel.fromMap(item.data());
          orderProductModels.add(model);

          var widgets = <Widget>[];
          for (var i = 0; i < model.docIdProducts.length; i++) {
            widgets.add(Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ShowText(lable: model.nameProducts[i]),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: 'ราคา : ${model.priceProducts[i]}'),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: 'จำนวน : ${model.amountProducts[i]}'),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: 'รวม : ${model.sumProducts[i]}'),
                ),
              ],
            ));
          }
          listWidget.add(widgets);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(model.uidBuyer)
              .get()
              .then((value) {
            UserModle userModle = UserModle.fromMap(value.data()!);
            userModels.add(userModle);
          });
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? newContent()
            : Center(
                child: ShowText(
                lable: 'ไม่มีรายการ สั่งซื้อ',
                textStyle: MyConstant().h1Style(),
              ));
  }

  Widget newContent() => ListView(
        children: [
          const ShowTitle(title: 'รายการสั่งซื่อ'),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: orderProductModels.length,
            itemBuilder: (context, index) => ExpansionTile(
              children: listWidget[index],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowTitle(title: 'ผู้ซื้อ : ${userModels[index].name}'),
                  ShowText(lable: 'สถานะ : ${orderProductModels[index].status}')
                ],
              ),
            ),
          )
        ],
      );
}
