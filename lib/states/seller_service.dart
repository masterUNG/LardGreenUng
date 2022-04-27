import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/states/order_seller.dart';
import 'package:lardgreenung/states/product_seller.dart';
import 'package:lardgreenung/states/profile_seller.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_image.dart';
import 'package:lardgreenung/widgets/show_menu.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_signout.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  bool load = true;
  var widgets = <Widget>[];
  int indexWidget = 0;
  var user = FirebaseAuth.instance.currentUser;
  UserModle? userModle;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<void> findUser() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      userModle = UserModle.fromMap(value.data()!);
      load = false;

      widgets.add(OrderSeller(
        docIdUser: user!.uid,
      ));
      widgets.add(ProfileSeller(
        docIdUser: user!.uid,
      ));
      widgets.add(ProductSeller(
        docIdUser: user!.uid,
      ));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: ShowText(
          lable: 'ส่วนสำหรับ ร้านค้า',
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: userModle == null
                  ? const SizedBox()
                  : userModle!.urlAvatar!.isEmpty
                      ? const ShowImage(
                          path: 'images/shop.png',
                        )
                      : Image.network(userModle!.urlAvatar!),
              decoration:
                  BoxDecoration(color: MyConstant.light.withOpacity(0.5)),
              accountName: ShowText(
                lable: userModle == null ? '' : userModle!.name,
                textStyle: MyConstant().h2Style(),
              ),
              accountEmail: ShowText(
                  lable: userModle == null ? '' : userModle!.email,
                  textStyle: MyConstant().h3Style()),
            ),
            ShowMenu(
              title: 'รายการสังของ',
              subTitle: 'Order ที่ลูกค้าสัง',
              iconData: Icons.shopping_basket,
              tapFunc: () {
                indexWidget = 0;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ShowMenu(
              title: 'จัดการ หน้าร้าน',
              subTitle: 'Edit Profile',
              iconData: Icons.shop,
              tapFunc: () {
                indexWidget = 1;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ShowMenu(
              title: 'จัดการสินค้า',
              subTitle: 'Manage Product',
              iconData: Icons.production_quantity_limits,
              tapFunc: () {
                indexWidget = 2;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            const Spacer(),
            const ShowSignOut(),
          ],
        ),
      ),
      body: load ? const ShowProgress() : widgets[indexWidget],
    );
  }
}
