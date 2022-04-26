import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lardgreenung/states/main_home.dart';
import 'package:lardgreenung/statewebsites/home_page.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final Map<String, WidgetBuilder> map = {
  MyConstant.routeMainHome: (context) => const MainHome(),
  MyConstant.routeHomePage: (context) => const HomePage(),
};

String? firstPage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    print('Firebase Initial Success');

    if (kIsWeb) {
      firstPage = MyConstant.routeHomePage;
    } else {
      firstPage = MyConstant.routeMainHome;
    }

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: firstPage,
      title: 'Lard Green Ung',
    );
  }
}
