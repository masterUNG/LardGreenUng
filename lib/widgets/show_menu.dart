// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class ShowMenu extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData iconData;
  final Function() tapFunc;
  const ShowMenu({
    Key? key,
    required this.title,
    this.subTitle,
    required this.iconData,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tapFunc,
      leading: Icon(
        iconData,
        color: MyConstant.dark,
      ),
      title: ShowText(
        lable: title,
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowText(lable: subTitle ?? ''),
    );
  }
}
