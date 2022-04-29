import 'package:flutter/material.dart';
import 'package:lardgreenung/models/sqlite_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/sqlite_helper.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_icon_button.dart';
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
  int total = 0;

  @override
  void initState() {
    super.initState();
    readMyChart();
  }

  Future<void> readMyChart() async {
    if (sqlModels.isNotEmpty) {
      sqlModels.clear();
      total = 0;
    }

    await SQLiteHelper().readAllDatabase().then((value) {
      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var item in value) {
          SQliteModel model = item;
          sqlModels.add(model);
          total = total + int.parse(model.sum);
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
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: sqlModels.length,
            itemBuilder: (context, index) => Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ShowText(lable: sqlModels[index].nameProduct),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].price),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].amount),
                ),
                Expanded(
                  flex: 1,
                  child: ShowText(lable: sqlModels[index].sum),
                ),
                Expanded(
                  flex: 1,
                  child: ShowIconButton(
                      iconData: Icons.delete_forever,
                      pressFunc: () async {
                        await SQLiteHelper()
                            .deleteWhereId(id: sqlModels[index].id!)
                            .then((value) {
                          readMyChart();
                        });
                      }),
                ),
              ],
            ),
          ),
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShowText(
                      lable: 'ผลรวมทั้งหมด :',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShowText(
                      lable: total.toString(),
                      textStyle: MyConstant().h1Style(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShowButton(
                color: Colors.red,
                width: 150,
                label: 'Empty Chart',
                pressFunc: () async {
                  await SQLiteHelper().deleteAllDatabase().then((value) {
                    readMyChart();
                  });
                },
              ),
              const SizedBox(
                width: 8,
              ),
              ShowButton(
                width: 150,
                label: 'Order',
                pressFunc: () {
                  processOrderProduct();
                },
              ),
            ],
          )
        ],
      );

  Future<void> processOrderProduct() async {
    
  }
}
