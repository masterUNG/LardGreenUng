import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lardgreenung/models/user_model.dart';

class MyFirebase {
  Future<UserModle> processFindUserModel({required String uid}) async {
    var result =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    UserModle userModle = UserModle.fromMap(result.data()!);
    return userModle;
  }

  String changeTimeStampToDateTime({required Timestamp timestamp}) {
    DateFormat dateFormat = DateFormat('dd MMM yyyyy HH:mm');
    DateTime dateTime = timestamp.toDate();
    String result = dateFormat.format(dateTime);
    return result;
  }
}
