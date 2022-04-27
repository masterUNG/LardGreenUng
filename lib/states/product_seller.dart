// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/product_model.dart';
import 'package:lardgreenung/states/add_new_product.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';

import 'package:lardgreenung/widgets/show_title.dart';

class ProductSeller extends StatefulWidget {
  final String docIdUser;
  const ProductSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<ProductSeller> createState() => _ProductSellerState();
}

class _ProductSellerState extends State<ProductSeller> {
  bool load = true;
  String? docIdUser;
  bool? haveProduct;
  var productModels = <ProductModel>[];

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    readProductData();
  }

  Future<void> readProductData() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .collection('product')
        .get()
        .then((value) {
      print('value ==>${value.docs}');
      load = false;

      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;

        for (var item in value.docs) {
          ProductModel productModel = ProductModel.fromMap(item.data());
          productModels.add(productModel);
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ShowButton(
          label: 'เพิ่มสินค้า',
          pressFunc: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewProduct(),
                )).then((value) => readProductData());
          }),
      body: load
          ? const ShowProgress()
          : haveProduct!
              ? newContent()
              : Center(
                  child: ShowText(
                    lable: 'ยังไม่มีสินค้า',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }

  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          children: [
            const ShowTitle(title: 'จัดการสินค้า'),
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: productModels.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: constarints.maxWidth * 0.5 - 8,
                        height: 120,
                        margin: const EdgeInsets.all(8),
                        child: Image.network(
                          productModels[index].urlProduct,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(padding: const EdgeInsets.all(8),
                        width: constarints.maxWidth * 0.5 - 8,
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShowText(
                              lable: productModels[index].name,
                              textStyle: MyConstant().h2Style(),
                            ),
                            ShowText(
                              lable: 'ราคา = ${productModels[index].price.toString()} บาท/${productModels[index].unit}',
                              textStyle: MyConstant().h3Style(),
                            ),
                            ShowText(
                              lable: 'Stock = ${productModels[index].stock.toString()} ${productModels[index].unit}',
                              textStyle: MyConstant().h3Style(),
                            ),
                           
                          ],
                        ),
                      ),
                    ],
                  ),
                   Divider(color: MyConstant.dark,)
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
