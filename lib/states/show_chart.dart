import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/models/sqlite_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/utility/sqlite_helper.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_icon_button.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class ShowChart extends StatefulWidget {
  const ShowChart({Key? key}) : super(key: key);

  @override
  State<ShowChart> createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  var sqlModels = <SQliteModel>[];
  bool load = true;
  bool? haveData;
  int total = 0;

  String delivery = 'รพ.รัฐภูมิ';
  var deliverys = <String>[];

  @override
  void initState() {
    super.initState();
    readMyChart();
    deliverys.add(delivery);
    deliverys.add('สี่แยกคูหา');
    deliverys.add('ที่อยู่ของผู้ซื้อ');
    deliverys.add('เขาพระ');
    deliverys.add('งาสีทอง');
  }

  Future<void> readMyChart() async {
    if (sqlModels.isNotEmpty) {
      sqlModels.clear();
      total = 0;
    }

    await SQLiteHelper().readAllDatabase().then((value) {
      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var item in value) {
          SQliteModel model = item;
          sqlModels.add(model);
          total = total + int.parse(model.sum);
        }
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'ตะกร้า',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: load
          ? const ShowProgress()
          : haveData!
              ? newContent()
              : Center(
                  child: ShowText(
                  lable: 'ยังไม่มีสินค้าใน ตระกร้า',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  Widget newContent() => Column(
        children: [
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              const ShowTitle(title: 'สินค้าจากร้าน :'),
              ShowText(lable: sqlModels[0].nameSeller)
            ],
          ),
          Row(
            children: [
              ShowTitle(title: 'สถานที่จัดส่ง :'),
              DropdownButton<dynamic>(
                value: delivery,
                items: deliverys
                    .map(
                      (e) => DropdownMenuItem(
                        child: ShowText(lable: e),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    delivery = value;
                  });
                },
              ),
            ],
          ),
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ShowText(
                  lable: 'สินค้า',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'ราคา',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'จำนวน',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'รวม',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
          Divider(
            color: MyConstant.dark,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: sqlModels.length,
            itemBuilder: (context, index) => Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ShowText(lable: sqlModels[index].nameProduct),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].price),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].amount),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].sum),
                ),
                Expanded(
                  flex: 1,
                  child: ShowIconButton(
                      iconData: Icons.delete_forever,
                      pressFunc: () async {
                        await SQLiteHelper()
                            .deleteWhereId(id: sqlModels[index].id!)
                            .then((value) {
                          readMyChart();
                        });
                      }),
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
                      lable: 'ผลรวมทั้งหมด :',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShowText(
                      lable: total.toString(),
                      textStyle: MyConstant().h1Style(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShowButton(
                color: Colors.red,
                width: 150,
                label: 'Empty Chart',
                pressFunc: () async {
                  await SQLiteHelper().deleteAllDatabase().then((value) {
                    readMyChart();
                  });
                },
              ),
              const SizedBox(
                width: 8,
              ),
              ShowButton(
                width: 150,
                label: 'Order',
                pressFunc: () {
                  processOrderProduct();
                },
              ),
            ],
          )
        ],
      );

  Future<void> processOrderProduct() async {
    var user = FirebaseAuth.instance.currentUser;
    DateTime dateTime = DateTime.now();
    Timestamp timeOrder = Timestamp.fromDate(dateTime);

    var docIdProducts = <String>[];
    var nameProducts = <String>[];
    var priceProducts = <String>[];
    var amountProducts = <String>[];
    var sumProducts = <String>[];

    for (var item in sqlModels) {
      docIdProducts.add(item.docIdProduct);
      nameProducts.add(item.nameProduct);
      priceProducts.add(item.price);
      amountProducts.add(item.amount);
      sumProducts.add(item.sum);
    }

    OrderProductModel orderProductModel = OrderProductModel(
      uidSeller: sqlModels[0].docIdSeller,
      uidBuyer: user!.uid,
      timeOrder: timeOrder,
      status: 'order',
      docIdProducts: docIdProducts,
      nameProducts: nameProducts,
      priceProducts: priceProducts,
      amountProducts: amountProducts,
      sumProducts: sumProducts,
      total: total.toString(),
      delivery: delivery,
    );

    await FirebaseFirestore.instance
        .collection('order')
        .doc()
        .set(orderProductModel.toMap())
        .then((value) async {
      //Sent Noti to Seller
      await FirebaseFirestore.instance
          .collection('user')
          .doc(sqlModels[0].docIdSeller)
          .get()
          .then((value) async {
        UserModle userModle = UserModle.fromMap(value.data()!);

        String token = userModle.token;
        String title = 'มีการสั่งซื่อเกิดขึ้น';
        String body = 'กรุณาดูที่ Order ด้วย มีการสั่งซื่อสินค้า';

        String path =
            'https://www.androidthai.in.th/bigc/noti/apiNotiUng.php?isAdd=true&token=$token&title=$title&body=$body';

        await Dio().get(path).then((value) async {
          print('Success Sent Noti');
          //Clear Chart
          await SQLiteHelper().deleteAllDatabase().then((value) {
            MyDialog(context: context).normalDialog(
                title: 'Order Success',
                message: 'ขอบคุณที่ใช้บริการ กรุณารอ การ Confirm จาก ร้านค้า');
            readMyChart();
          });
        });
      });
    });
  }
}
