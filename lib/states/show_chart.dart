import 'package:flutter/material.dart';
import 'package:lardgreenung/models/sqlite_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/sqlite_helper.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';
import 'package:lardgreenung/widgets/show_title.dart';

class ShowChart extends StatefulWidget {
  const ShowChart({Key? key}) : super(key: key);

  @override
  State<ShowChart> createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  var sqlModels = <SQliteModel>[];
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    readMyChart();
  }

  Future<void> readMyChart() async {
    if (sqlModels.isNotEmpty) {
      sqlModels.clear();
    }

    await SQLiteHelper().readAllDatabase().then((value) {
      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var item in value) {
          SQliteModel model = item;
          sqlModels.add(model);
        }
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
        title: ShowText(
          lable: 'ตะกร้า',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: load
          ? const ShowProgress()
          : haveData!
              ? newContent()
              : Center(
                  child: ShowText(
                  lable: 'ยังไม่มีสินค้าใน ตระกร้า',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  Widget newContent() => Column(
        children: [
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              const ShowTitle(title: 'สินค้าจากร้าน :'),
              ShowText(lable: sqlModels[0].nameSeller)
            ],
          ),
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ShowText(
                  lable: 'สินค้า',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'ราคา',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'จำนวน',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'รวม',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
          Divider(
            color: MyConstant.dark,
          ),
         
        ],
      );
}
