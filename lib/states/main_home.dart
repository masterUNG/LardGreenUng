import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/states/authen.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_menu.dart';
import 'package:lardgreenung/widgets/show_signout.dart';

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

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<void> readDataUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        logined = false;
      } else {
        logined = true;
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
      drawer: logined! ? drawerBuyer(context) : drawerGuest(context) ,
    );
  }

  Drawer drawerGuest(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(accountName: null, accountEmail: null),
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
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          Spacer(),
          ShowSignOut(),
        ],
      ),
    );
  }
}
