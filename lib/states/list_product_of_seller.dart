// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/product_model.dart';

import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/states/show_detail_product.dart';
import 'package:lardgreenung/utility/my_calculate.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class ListProductOfSeller extends StatefulWidget {
  final String docIdUser;
  final UserModle userModle;
  const ListProductOfSeller({
    Key? key,
    required this.docIdUser,
    required this.userModle,
  }) : super(key: key);

  @override
  State<ListProductOfSeller> createState() => _ListProductOfSellerState();
}

class _ListProductOfSellerState extends State<ListProductOfSeller> {
  String? docIdUser;
  UserModle? userModle;
  bool load = true;
  bool? haveProduct;
  var productModels = <ProductModel>[];
  var docIdProducts = <String>[];

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    userModle = widget.userModle;
    readSellerProduct();
  }

  Future<void> readSellerProduct() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .collection('product')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;
        for (var item in value.docs) {
          ProductModel productModel = ProductModel.fromMap(item.data());
          productModels.add(productModel);
          docIdProducts.add(item.id);
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
        title: ShowText(lable: userModle!.name),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => load
            ? const ShowProgress()
            : haveProduct!
                ? ListView.builder(
                    itemCount: productModels.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDetailProduct(
                                  docIdUser: docIdUser!,
                                  docIdProduct: docIdProducts[index],
                                  productModel: productModels[index]),
                            ));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: constraints.maxWidth * 0.5 - 8,
                              height: constraints.maxWidth * 0.4,
                              child: Image.network(
                                productModels[index].urlProduct,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: constraints.maxWidth * 0.5,
                              height: constraints.maxWidth * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShowText(
                                    lable: productModels[index].name,
                                    textStyle: MyConstant().h2Style(),
                                  ),
                                  ShowText(
                                      lable:
                                          'ราคา ${productModels[index].price} บาท/${productModels[index].unit}'),
                                  ShowText(
                                      lable:
                                          'Stock = ${productModels[index].stock} ${productModels[index].unit}'),
                                  ShowText(
                                      lable:
                                          'รายละเอียดสินค้า : ${MyCalculate().cutWord(string: productModels[index].detail)}')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: ShowText(
                      lable: 'ยังไม่มี สินค้า',
                      textStyle: MyConstant().h1Style(),
                    ),
                  ),
      ),
    );
  }
}
