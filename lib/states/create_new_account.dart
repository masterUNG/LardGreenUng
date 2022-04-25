import 'package:flutter/material.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_form.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  var typeUsers = <String>[
    'buyer',
    'seller',
  ];

  var tupeUserThs = <String>[
    'ผู้ซื้อ',
    'ผู้ขาย',
  ];

  String? typeUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'สมัครสมาชิกใหม่',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(
          FocusScopeNode(),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowForm(
                    label: 'ชื่อ : ',
                    iconData: Icons.fingerprint,
                    changeFunc: (String string) {},
                  ),
                ),
              ],
            ),
            const ShowTitle(
              title: 'ชนิดของสมาชิก :',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: DropdownButton<dynamic>(
                    value: typeUser,
                    items: typeUsers
                        .map(
                          (e) => DropdownMenuItem(
                            child: ShowText(lable: e),
                            value: e,
                          ),
                        )
                        .toList(),
                    hint: const ShowText(lable: 'กรุณาเลือกชนิดของสมาชิก'),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowForm(
                    textInputType: TextInputType.emailAddress,
                    label: 'อีเมล์ : ',
                    iconData: Icons.email_outlined,
                    changeFunc: (String string) {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowForm(
                    label: 'รหัสผ่าน : ',
                    iconData: Icons.lock_outline,
                    changeFunc: (String string) {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowForm(
                    label: 'ที่อยู่ : ',
                    iconData: Icons.home_outlined,
                    changeFunc: (String string) {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowForm(
                    textInputType: TextInputType.phone,
                    label: 'เบอร์โทรศัพย์ : ',
                    iconData: Icons.phone,
                    changeFunc: (String string) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
