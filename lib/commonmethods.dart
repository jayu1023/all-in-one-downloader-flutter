import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class CommonMethod {
  static replaceAndJumpToNext(Widget nextscreen) {
    Get.to(() => nextscreen);
  }

  static showGetSnackBar(String msg, String title) {
    Get.snackbar(title, msg);
  }
}

