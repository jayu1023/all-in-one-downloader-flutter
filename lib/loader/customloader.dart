import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomLoader {
  static showLoader() {
    EasyLoading.show();
  }

  static showSuccessLoader(String msg) {
    EasyLoading.showSuccess(msg);
  }

  static showErrorLoader(String msg) {
    EasyLoading.showError(msg);
  }

  static dismissLoader() {
    EasyLoading.dismiss();
  }

  static showMsgLoader(String msg) {
    EasyLoading.showInfo(msg);
  }
}
