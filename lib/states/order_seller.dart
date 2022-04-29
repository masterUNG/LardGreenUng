// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/widgets/show_icon_button.dart';
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
  var docIdOrders = <String>[];

  @override
  void initState() {
    super.initState();
    readMyOrder();
  }

  Future<void> readMyOrder() async {
    if (orderProductModels.isNotEmpty) {
      orderProductModels.clear();
      docIdOrders.clear();
      userModels.clear();
      listWidget.clear();
    }

    var user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    print('## uid ==> $uid');

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
          docIdOrders.add(item.id);

          var widgets = <Widget>[];
          for (var i = 0; i < model.docIdProducts.length; i++) {
            widgets.add(Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ShowText(lable: model.nameProducts[i]),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(lable: model.priceProducts[i]),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(lable: model.amountProducts[i]),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(lable: model.sumProducts[i]),
                    ),
                  ],
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
                  ShowText(
                      lable: 'สถานะ : ${orderProductModels[index].status}'),
                  ShowIconButton(
                      iconData: Icons.edit_outlined,
                      pressFunc: () async {
                        print('you click ==> $index');

                        Map<String, dynamic> map = {};
                        MyDialog(context: context).actionDialog(
                            title: 'Choose New Status',
                            message: 'Please Choose Confire or Cancel',
                            label1: 'Confirm',
                            label2: 'Cancel',
                            presFunc1: () {
                              map['status'] = 'confirm';
                              Navigator.pop(context);
                              processChangeStatus(
                                  docIdOrder: docIdOrders[index],
                                  map: map,
                                  docIdBuyer:
                                      orderProductModels[index].uidBuyer);
                            },
                            presFunc2: () {
                              map['status'] = 'cancel';
                              Navigator.pop(context);
                              processChangeStatus(
                                  docIdOrder: docIdOrders[index],
                                  map: map,
                                  docIdBuyer:
                                      orderProductModels[index].uidBuyer);
                            });
                      }),
                ],
              ),
            ),
          )
        ],
      );

  Future<void> processChangeStatus(
      {required String docIdOrder,
      required Map<String, dynamic> map,
      required String docIdBuyer}) async {
    await FirebaseFirestore.instance
        .collection('order')
        .doc(docIdOrder)
        .update(map)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docIdBuyer)
          .get()
          .then((value) async {
        UserModle modle = UserModle.fromMap(value.data()!);
        String token = modle.token;
        String title = 'Order ${map['status']}';
        String body = 'ขอบคุณ คะ';

        print('token ==> $token');

        String path =
            'https://www.androidthai.in.th/bigc/noti/apiNotiUng.php?isAdd=true&token=$token&title=$title&body=$body';

        await Dio().get(path).then((value) {
          readMyOrder();
        });
      });
    });
  }
}
