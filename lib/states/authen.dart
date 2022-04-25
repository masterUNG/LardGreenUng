import 'package:flutter/material.dart';
import 'package:lardgreenung/states/create_new_account.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_form.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_text_button.dart';

class Authen extends StatelessWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowText(
                lable: 'ลงชื่อใช้งาน',
                textStyle: MyConstant().h1Style(),
              ),
              ShowForm(
                label: 'อีเมล์ :',
                iconData: Icons.email_outlined,
                changeFunc: (String string) {},
              ),
              ShowForm(
                label: 'รหัสผ่าน :',
                iconData: Icons.lock_outline,
                changeFunc: (String string) {},
              ),
              ShowButton(
                label: 'ลงชื่อใช้งาน',
                pressFunc: () {},
              ),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShowTextButton(
                      label: 'ลืมรหัสผ่าน',
                      pressFunc: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ShowText(lable: 'ไม่มีชื่อผู้ใช้งาน ? '),
                    ShowTextButton(
                      label: 'สมัครเข้าใช้งาน',
                      pressFunc: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateNewAccount(),
                            ));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
