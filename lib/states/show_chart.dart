import 'package:flutter/material.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/sqlite_helper.dart';

class ShowChart extends StatefulWidget {
  const ShowChart({Key? key}) : super(key: key);

  @override
  State<ShowChart> createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  @override
  void initState() {
    super.initState();
    readMyChart();
  }

  Future<void> readMyChart() async {
    print('readMyChart Work');
    await SQLiteHelper().readAllDatabase().then((value) {
      print('value SQLite ==>> $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
    );
  }
}
