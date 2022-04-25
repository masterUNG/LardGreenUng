import 'package:flutter/material.dart';
import 'package:lardgreenung/states/authen.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_menu.dart';

class MainHome extends StatelessWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
                accountName: null, accountEmail: null),
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
      ),
    );
  }
}
