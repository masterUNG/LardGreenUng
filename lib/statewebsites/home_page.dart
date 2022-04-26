import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/statewebsites/check_approve_user.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_form.dart';
import 'package:lardgreenung/widgets/show_image.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 200,
              height: 200,
              child: ShowImage(),
            ),
            ShowText(
              lable: 'Login',
              textStyle: MyConstant().h1Style(),
            ),
            Row(
              children: [
                ShowForm(
                  label: 'Email :',
                  iconData: Icons.email_outlined,
                  changeFunc: (String string) {
                    email = string.trim();
                  },
                ),
                const SizedBox(
                  width: 36,
                ),
                ShowForm(
                  obscue: true,
                  label: 'Password :',
                  iconData: Icons.lock_outline,
                  changeFunc: (String string) {
                    password = string.trim();
                  },
                ),
              ],
            ),
            SizedBox(
              width: 536,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShowButton(
                    label: 'Login',
                    pressFunc: () {
                      if ((email?.isEmpty ?? true) ||
                          (password?.isEmpty ?? true)) {
                        MyDialog(context: context).normalDialog(
                            title: 'มีช่องว่าง',
                            message: 'กรูณากรอก ทุกช่อง คะ');
                      } else {
                        processCheckAuthen();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processCheckAuthen() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;
      print('uid ===>> $uid');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) {
        UserModle userModle = UserModle.fromMap(value.data()!);
        if (userModle.status != 'approve') {
          MyDialog(context: context).normalDialog(
              title: 'Account นี่ยังไม่ Approve',
              message: 'กรุณารอ Approve ก่อน');
        } else if (userModle.typeUser == 'admin') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckApproveUser(),
              ),
              (route) => false);
        } else {
          MyDialog(context: context).normalDialog(
              title: 'TypeUser ไม่ใช่ Admin',
              message:
                  'TypeUser ของคุณเป็น ${userModle.typeUser} จึงไม่สามารถเข้าหน้า Admin ได้ คะ');
        }
      });
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, message: onError.message);
    });
  }
}
