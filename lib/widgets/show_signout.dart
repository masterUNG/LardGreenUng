import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_menu.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 204, 68, 58).withOpacity(0.5)),
      child: ShowMenu(
        title: 'ออกจากระบบ',
        subTitle: 'SignOut',
        iconData: Icons.exit_to_app,
        tapFunc: () async {
          await FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeMainHome, (route) => false);
          });
        },
      ),
    );
  }
}
