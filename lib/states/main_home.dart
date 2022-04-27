import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/states/about_me.dart';
import 'package:lardgreenung/states/authen.dart';
import 'package:lardgreenung/states/helper.dart';
import 'package:lardgreenung/states/home.dart';
import 'package:lardgreenung/utility/my_constant.dart';
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

  @override
  void initState() {
    super.initState();

    widgetGuests.add(const Home());
    widgetGuests.add(const Helper());
    widgetGuests.add(const AboutMe());

    widgetBuyer.add(const Home());

    readDataUser();
  }

  Future<void> readDataUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event == null) {
        logined = false;
        widgets = widgetGuests;
      } else {
        logined = true;
        widgets = widgetBuyer;

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
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Authen(),
                  ));
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
            accountName: ShowText(lable: userModle!.name, textStyle: MyConstant().h2Style(),),
            accountEmail: ShowText(lable: userModle!.email, textStyle: MyConstant().h3ActionStyle(),),
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
          const Spacer(),
          const ShowSignOut(),
        ],
      ),
    );
  }
}
