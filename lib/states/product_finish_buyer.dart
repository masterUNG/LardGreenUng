import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/utility/my_firebase.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class ProductFinishBuyer extends StatefulWidget {
  const ProductFinishBuyer({Key? key}) : super(key: key);

  @override
  State<ProductFinishBuyer> createState() => _ProductFinishBuyerState();
}

class _ProductFinishBuyerState extends State<ProductFinishBuyer> {
  var user = FirebaseAuth.instance.currentUser;
  var orderProductModels = <OrderProductModel>[];
  var sellerUserModels = <UserModle>[];
  var dateOrders = <String>[];
  var docIdOrders = <String>[];
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    readOrderProduct();
  }

  Future<void> readOrderProduct() async {
    if (orderProductModels.isNotEmpty) {
      orderProductModels.clear();
      sellerUserModels.clear();
      dateOrders.clear();
      docIdOrders.clear();
    }

    await FirebaseFirestore.instance
        .collection('order')
        .where('uidBuyer', isEqualTo: user!.uid)
        .where('status', isEqualTo: 'finish')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var element in value.docs) {
          OrderProductModel orderProductModel =
              OrderProductModel.fromMap(element.data());
          orderProductModels.add(orderProductModel);
          UserModle userModle = await MyFirebase()
              .processFindUserModel(uid: orderProductModel.uidSeller);
          sellerUserModels.add(userModle);
          dateOrders.add(MyFirebase().changeTimeStampToDateTime(
              timestamp: orderProductModel.timeOrder));
          docIdOrders.add(element.id);
        }
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveData!
            ? newContent()
            : Center(
                child: ShowText(
                lable: 'ไม่มี สำเร็จเลย',
                textStyle: MyConstant().h1Style(),
              ));
  }

  Widget newContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ShowTitle(title: 'รายการส่งของสำเร็จ'),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: orderProductModels.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowText(
                  lable: 'ร้าน : ${sellerUserModels[index].name}',
                  textStyle: MyConstant().h2Style(),
                ),
                ShowText(lable: dateOrders[index]),
                Divider(
                  color: MyConstant.dark,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: orderProductModels[index].nameProducts.length,
                  itemBuilder: (context, index2) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ShowText(
                            lable:
                                orderProductModels[index].nameProducts[index2]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(
                            lable:
                                orderProductModels[index].priceProducts[index2]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(
                            lable:
                                orderProductModels[index].amountProducts[index2]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(
                            lable: orderProductModels[index].sumProducts[index2]),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: MyConstant.dark,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ShowText(
                            lable: 'ผลรวม :  ',
                            textStyle: MyConstant().h2Style(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: ShowText(
                          lable: orderProductModels[index].total,
                          textStyle: MyConstant().h2Style(),
                        )),
                  ],
                ),
               
                Divider(
                  color: MyConstant.dark,
                  thickness: 4,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

 
}
