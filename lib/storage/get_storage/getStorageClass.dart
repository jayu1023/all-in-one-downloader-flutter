import 'package:get_storage/get_storage.dart';

class GetStorageClass {
  static late GetStorage box;
  static GetStorage? getStorage;
  static final GetStorageClass _instance = GetStorageClass._internal();
  factory GetStorageClass() {
    return _instance;
  }
  GetStorageClass._internal() {
    box = GetStorage();

    // initialization logic
  }
  readData(String key) {
    return box.read(key) ?? false;
  }

  writeData(String key, dynamic data) {
    return box.write(key, data);
  }
  // call this method from iniState() function of mainApp().

}
