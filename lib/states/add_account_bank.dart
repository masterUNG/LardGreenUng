// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/models/bank_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_form.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class AddAccounBank extends StatefulWidget {
  final String docId;
  const AddAccounBank({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<AddAccounBank> createState() => _AddAccounBankState();
}

class _AddAccounBankState extends State<AddAccounBank> {
  var nameBanks = [];
  var svgBanks = [];
  var indexs = <int>[0, 1, 2, 3, 4];

  String? nameBank, svgBank, nameAccountBank, accountBank;
  int? indexBank;

  @override
  void initState() {
    super.initState();

    nameBanks.addAll(MyConstant.nameBanks);
    svgBanks.addAll(MyConstant.svgBanks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'เพิ่มบัญชี ธนาคาร',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Center(
          child: Column(
            children: [
              // SvgPicture.asset('images/test.svg'),
              newDropDownNameBank(),
              ShowForm(
                label: 'ชื่อบัญชีธนาคาร',
                iconData: Icons.fingerprint,
                changeFunc: (String string) {
                  nameAccountBank = string.trim();
                },
              ),
              ShowForm(
                maxLength: 10,
                textInputType: TextInputType.number,
                label: 'หมายเลขบัญชีธนาคาร',
                iconData: Icons.account_balance,
                changeFunc: (String string) {
                  accountBank = string.trim();
                },
              ),
              ShowButton(
                label: 'บันทึกบัญชีธนาคาร',
                pressFunc: () {
                  if (indexBank == null) {
                    MyDialog(context: context).normalDialog(
                        title: 'ชื่อธนาคาร ?',
                        message: 'โปรดเลือกธนาคารด้วย คะ');
                  } else if ((nameAccountBank?.isEmpty ?? true) ||
                      (accountBank?.isEmpty ?? true)) {
                    MyDialog(context: context).normalDialog(
                        title: 'มีช่องว่าง ?', message: 'กรุณากรอกทุกช่องคะ');
                  } else if (accountBank!.length != 10) {
                    MyDialog(context: context).normalDialog(
                        title: 'เลขบัญชีผิด', message: 'เลขบัญชีไม่ครบ');
                  } else {
                    processSaveBank();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<dynamic> newDropDownNameBank() {
    return DropdownButton<dynamic>(
      hint: const ShowText(lable: 'โปรดเลือกธนาคาร'),
      value: indexBank,
      items: indexs
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: ShowText(
                lable: nameBanks[e],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          indexBank = value;
        });
      },
    );
  }

  Future<void> processSaveBank() async {
    BankModel bankModel = BankModel(
        nameBank: nameBanks[indexBank!],
        nameAccountBank: nameAccountBank!,
        accountBank: accountBank!);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docId)
        .collection('bank')
        .doc()
        .set(bankModel.toMap())
        .then((value) {
      Navigator.pop(context);
    });
  }
}
