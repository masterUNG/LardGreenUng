class MyCalculate {
  String cutWord({required String string}) {
    String result = string;
    if (result.length > 20) {
      result = result.substring(0, 20);
      result = '$result ...';
    }
    return result;
  }
}
