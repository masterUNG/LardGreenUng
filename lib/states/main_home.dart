import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/order_product_model.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/states/about_me.dart';
import 'package:lardgreenung/states/authen.dart';
import 'package:lardgreenung/states/helper.dart';
import 'package:lardgreenung/states/home.dart';
import 'package:lardgreenung/states/product_cancel_buyer.dart';
import 'package:lardgreenung/states/product_confirm_buyer.dart';
import 'package:lardgreenung/states/product_finish_buyer.dart';
import 'package:lardgreenung/states/product_order_buyer.dart';
import 'package:lardgreenung/states/product_payment_buyer.dart';
import 'package:lardgreenung/states/show_chart.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/widgets/show_icon_button.dart';
import 'package:lardgreenung/widgets/show_image.dart';
import 'package:lardgreenung/widgets/show_menu.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_signout.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool load = true;
  bool? logined;

  var widgetGuests = <Widget>[];
  var widgetBuyer = <Widget>[];
  var widgets = <Widget>[];

  int indexWidget = 0;
  var user = FirebaseAuth.instance.currentUser;
  UserModle? userModle;
  String? titleMessage, bodyMessage, token;

  @override
  void initState() {
    super.initState();

    widgetGuests.add(const Home());
    widgetGuests.add(const Helper());
    widgetGuests.add(const AboutMe());

    widgetBuyer.add(const Home());
    widgetBuyer.add(const ProductOrderBuyer());
    widgetBuyer.add(const ProductConfirmBuyer());
    widgetBuyer.add(const ProductPaymentBuyer());
    widgetBuyer.add(const ProductFinishBuyer());
    widgetBuyer.add(const ProductCancelBuyer());

    readDataUser();
  }

  Future<void> processMessageing() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      token = value.toString();
      print('token สำหรับ ผู้ซื้อ ==> $token');

      Map<String, dynamic> map = {};
      map['token'] = token;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .update(map)
          .then((value) {
        print('UPdate Token Success');
      });
    });

    // for OpenApp
    FirebaseMessaging.onMessage.listen((event) {
      titleMessage = event.notification!.title;
      bodyMessage = event.notification!.body;
      MyDialog(context: context)
          .normalDialog(title: titleMessage!, message: bodyMessage!);
    });

    // for CloseApp
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      titleMessage = event.notification!.title;
      bodyMessage = event.notification!.body;
      print('message -->> $titleMessage, $bodyMessage');
    });
  }

  Future<void> readDataUser() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event == null) {
        logined = false;
        widgets = widgetGuests;
      } else {
        logined = true;
        widgets = widgetBuyer;

        processMessageing();

        await FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .get()
            .then((value) {
          userModle = UserModle.fromMap(value.data()!);
        });
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
        actions: [
          ShowIconButton(
            iconData: Icons.shopping_cart_outlined,
            pressFunc: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShowChart(),
                  ));
            },
          ),
        ],
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      drawer: load
          ? null
          : logined!
              ? drawerBuyer(context)
              : drawerGuest(context),
      body: load ? const ShowProgress() : widgets[indexWidget],
    );
  }

  Drawer drawerGuest(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const ShowImage(),
            decoration: BoxDecoration(
              color: MyConstant.light.withOpacity(0.5),
            ),
            accountName: ShowText(
              lable: 'ยังไม่ได้ลงชื่อเข้าใช้งาน',
              textStyle: MyConstant().h2Style(),
            ),
            accountEmail: ShowText(
              lable: 'กรุณาลงชื่อเข้าใช้งาน โดยคลิกที่ สมาชิก',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ShowMenu(
            title: 'Home',
            iconData: Icons.home_outlined,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 0;
              });
            },
          ),
          ShowMenu(
            title: 'Helper',
            iconData: Icons.help_outline,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 1;
              });
            },
          ),
          ShowMenu(
            title: 'About Me',
            iconData: Icons.android,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 2;
              });
            },
          ),
          const Spacer(),
          ShowMenu(
            subTitle: 'ลงชื่อใช้งาน หรือ สมัครสมาชิก',
            title: 'สมาชิก',
            iconData: Icons.card_membership,
            tapFunc: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Authen(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Drawer drawerBuyer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: MyConstant.light.withOpacity(0.5)),
            currentAccountPicture: const ShowImage(),
            accountName: ShowText(
              lable: userModle!.name,
              textStyle: MyConstant().h2Style(),
            ),
            accountEmail: ShowText(
              lable: userModle!.email,
              textStyle: MyConstant().h3ActionStyle(),
            ),
          ),
          ShowMenu(
            title: 'เลือกซื้อสินค้า',
            iconData: Icons.filter_1,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 0;
              });
            },
          ),
          ShowMenu(
            title: 'รายการสั่งสินค้า',
            iconData: Icons.filter_2,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 1;
              });
            },
          ),
          ShowMenu(
            title: 'รายการยืนยันสินค้า',
            iconData: Icons.filter_3,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 2;
              });
            },
          ),
          ShowMenu(
            title: 'รายการจ่ายเงิน',
            iconData: Icons.filter_4,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 3;
              });
            },
          ),
          ShowMenu(
            title: 'สินค้าท่ี่จัดส่งแล้ว',
            iconData: Icons.filter_5,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 4;
              });
            },
          ),
          ShowMenu(
            title: 'สินค้าที่ยกเลิก',
            iconData: Icons.filter_6,
            tapFunc: () {
              Navigator.pop(context);
              setState(() {
                indexWidget = 5;
              });
            },
          ),
          const Spacer(),
          const ShowSignOut(),
        ],
      ),
    );
  }
}
