import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/product_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/states/list_product_of_seller.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_image.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userModels = <UserModle>[];
  var productModels = <ProductModel>[];
  var docIdUsers = <String>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    readAllSeller();
  }

  Future<void> readAllSeller() async {
    // for GridView Seller
    await FirebaseFirestore.instance
        .collection('user')
        .where('typeUser', isEqualTo: 'seller')
        .get()
        .then((value) async {
      load = false;

      int i = 0;
      for (var item in value.docs) {
        UserModle userModle = UserModle.fromMap(item.data());
        if (i <= 5) {
          userModels.add(userModle);
        }
        i++;

        String docIdUser = item.id;
        docIdUsers.add(docIdUser);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(docIdUser)
            .collection('product')
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var item in value.docs) {
              ProductModel productModel = ProductModel.fromMap(item.data());
              productModels.add(productModel);
            }
          }
        });
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return load
          ? const ShowProgress()
          : ListView(
              children: [
                const ShowTitle(title: 'โปรโมชั่น :'),
                newBanner(constraints),
                const ShowTitle(title: 'ร้านค้า :'),
                newSellerGroup(),
                const ShowTitle(title: 'สินค้า ใหม่ :'),
                newProductGroup(),
              ],
            );
    });
  }

  GridView newProductGroup() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) => Card(
        color: Color.fromARGB(255, 206, 58, 107).withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.network(productModels[index].urlProduct),
            ),
            ShowText(lable: productModels[index].name),
          ],
        ),
      ),
      itemCount: productModels.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
    );
  }

  GridView newSellerGroup() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListProductOfSeller(
                    docIdUser: docIdUsers[index], userModle: userModels[index]),
              ));
        },
        child: Card(
          color: Colors.lime,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: userModels[index].urlAvatar!.isEmpty
                    ? const ShowImage(
                        path: 'images/shop.png',
                      )
                    : Image.network(
                        userModels[index].urlAvatar!,
                        fit: BoxFit.cover,
                      ),
              ),
              ShowText(lable: userModels[index].name),
            ],
          ),
        ),
      ),
      itemCount: userModels.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Container newBanner(BoxConstraints constraints) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: MyConstant.light.withOpacity(0.75)),
      width: constraints.maxWidth,
      height: 150,
      child: ShowText(
        lable: 'Banner',
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
