// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lardgreenung/models/product_model.dart';
import 'package:lardgreenung/models/sqlite_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/utility/sqlite_helper.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_form.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class ShowDetailProduct extends StatefulWidget {
  final String docIdUser;
  final String docIdProduct;
  final ProductModel productModel;
  const ShowDetailProduct({
    Key? key,
    required this.docIdUser,
    required this.docIdProduct,
    required this.productModel,
  }) : super(key: key);

  @override
  State<ShowDetailProduct> createState() => _ShowDetailProductState();
}

class _ShowDetailProductState extends State<ShowDetailProduct> {
  String? docIdUser, docIdProduct;
  ProductModel? productModel;
  bool load = true;
  UserModle? userModle;
  String? amount;
  SQliteModel? sQliteModel2;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    docIdProduct = widget.docIdProduct;
    productModel = widget.productModel;
    readSeller();
  }

  Future<void> readSeller() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .get()
        .then((value) {
      userModle = UserModle.fromMap(value.data()!);
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(lable: load ? '' : 'ร้านค้า ${userModle!.name}'),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: constraints.maxWidth,
                height: constraints.maxWidth * 0.75,
                child: Image.network(
                  productModel!.urlProduct,
                  fit: BoxFit.cover,
                ),
              ),
              newDetail(head: 'ชื่อสินค้า :', value: productModel!.name),
              newDetail(
                  head: 'ราคา :',
                  value: '${productModel!.price} บาท / ${productModel!.unit}'),
              newDetail(
                  head: 'Stock :',
                  value: '${productModel!.stock} ${productModel!.unit}'),
              newDetail(head: 'รายละเอียด :', value: productModel!.detail),
              newAmount(),
              ShowButton(
                  label: 'ใส่ ตระกล้า',
                  pressFunc: () {
                    if (user == null) {
                      MyDialog(context: context).normalDialog(
                          title: 'ยังไม่ได่ Login',
                          message: 'โปรดไป Login ก่อน');
                    } else if (amount?.isEmpty ?? true) {
                      MyDialog(context: context).normalDialog(
                          title: 'ยังไม่มี จำนวนที่สั่ง ?',
                          message: 'กรุณาใส่ จำนวนที่สั่งด้วย คะ');
                    } else if (int.parse(amount!) > productModel!.stock) {
                      MyDialog(context: context).actionDialog(
                          title: 'คุณสั่งของมากกว่า Stock ที่มี ?',
                          message: 'รอคิดต่อกลับจาก Admin ก่อน',
                          label1: 'จอง',
                          label2: 'Cancel',
                          presFunc1: () {
                            Navigator.pop(context);
                          },
                          presFunc2: () {
                            Navigator.pop(context);
                          });
                    } else {
                      processAddChart();
                    }
                  }),
            ],
          ),
        );
      }),
    );
  }

  Row newAmount() {
    return Row(
      children: [
        const ShowTitle(title: 'จำนวนที่สั่ง :'),
        ShowForm(
            width: 180,
            textInputType: TextInputType.number,
            label: 'จำนวนที่สั่ง',
            iconData: Icons.book,
            changeFunc: (String string) {
              amount = string.trim();
            }),
      ],
    );
  }

  Row newDetail({required String head, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: ShowTitle(title: head),
        ),
        Expanded(
          flex: 2,
          child: ShowText(lable: value),
        ),
      ],
    );
  }

  Future<void> processAddChart() async {
    SQliteModel sQliteModel = SQliteModel(
        docIdSeller: docIdUser!,
        nameSeller: userModle!.name,
        docIdProduct: docIdProduct!,
        nameProduct: productModel!.name,
        price: productModel!.price.toString(),
        amount: amount!,
        sum: (productModel!.price * int.parse(amount!)).toString());

    await SQLiteHelper().readAllDatabase().then((value) async {
      print('value l ==> ${value.length}');
      if (value.isEmpty) {
        await SQLiteHelper()
            .insertNewValue(sQliteModel: sQliteModel)
            .then((value) {
          Navigator.pop(context);
        });
      } else {
        for (var item in value) {
          sQliteModel2 = item;
        }

        print('name seller ==> ${sQliteModel2!.nameSeller}');

        if (sQliteModel.docIdSeller == sQliteModel2!.docIdSeller) {
          await SQLiteHelper()
              .insertNewValue(sQliteModel: sQliteModel)
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          MyDialog(context: context).normalDialog(
              title: 'ผิดร้าน',
              message:
                  'กรุณาซือจากร้าน ${sQliteModel2!.nameSeller} ให้เสร็จก่อน');
        }
      }
    });
  }
}
