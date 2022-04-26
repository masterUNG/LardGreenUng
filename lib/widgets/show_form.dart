// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function(String) changeFunc;
  final TextInputType? textInputType;
  final bool? obscue;
  const ShowForm({
    Key? key,
    required this.label,
    required this.iconData,
    required this.changeFunc,
    this.textInputType,
    this.obscue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(obscureText: obscue ?? false,
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: changeFunc,
        decoration: InputDecoration(
          suffixIcon: Icon(
            iconData,
            color: MyConstant.dark,
          ),
          label: ShowText(lable: label),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyConstant.dark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyConstant.light),
          ),
        ),
      ),
    );
  }
}
