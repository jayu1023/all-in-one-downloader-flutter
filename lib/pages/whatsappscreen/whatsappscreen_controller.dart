import 'dart:io';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../loader/customloader.dart';

class WhatsappScreen_controller extends GetxController {
  RxBool isWpInstall = false.obs;
  RxBool isPermissionGranted = false.obs;
  RxBool isNoStatus = false.obs;

  Directory storDir = Directory('/storage/emulated/0/Pictures/');
  Directory picDir = Directory('/storage/emulated/0/Whatsapp/media/.Statuses');
  // Directory picDir = Directory('/storage/emulated/0/download');

  Directory picDirAnd11 = Directory(
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses/');
  //   Directory picDirAnd11 = Directory(
  // '/storage/emulated/0/download');

  RxList<String> imagelist = <String>[].obs;
  RxList<String> videolist = <String>[].obs;

  RxList<String> storedlist = <String>[].obs;
  RxList<String> storedListall = <String>[].obs;

  RxList<String> videoThumbList = <String>[].obs;
  RxList<String> list = <String>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // CustomLoader.showLoader();

    chekPermissionGranted();
  }

  ///
  ///[chekPermissionGranted] used to check permission of storage
  ///
  void chekPermissionGranted() async {
    int? sdkInt, release;
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    release = int.parse(androidInfo.version.release.toString());
    sdkInt = androidInfo.version.sdkInt ?? 0;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    // print('Android $release (SDK $sdkInt), $manufacturer $model');

    if (sdkInt < 30) {
      print("lesss thean 30");
      if (await Permission.storage.isGranted) {
        isPermissionGranted.value = true;
        checkWpInstall();
      } else {
        if (await Permission.storage.isDenied ||
            await Permission.storage.isPermanentlyDenied) {
          PermissionStatus pms = await Permission.storage.request();
          pms == PermissionStatus.denied ||
                  pms == PermissionStatus.permanentlyDenied
              ? chekPermissionGranted()
              : chekPermissionGranted();
        }
      }
    } else {
      print("great thean 30");

      // if (await Permission.storage.isGranted &&
      //     await Permission.manageExternalStorage.isGranted) {
      //   isPermissionGranted.value = true;
      //   checkWpInstall();
      // } else {
      //   // bool permissionstatus = false;

      //   // You can request multiple permissions at once.

      //   Permission.storage.request().then((value) {
      //     if (value.isGranted) {
      //       Permission.manageExternalStorage.request().then((value) {
      //         checkWpInstall();
      //       });
      //     } else {
      //       chekPermissionGranted();
      //     }
      //   });
      // }
    }
  }

  ///
  ///[checkWpInstall] used to check weathr wp is installed or not??
  ///
  void checkWpInstall() async {
    int? sdkInt, release;
    try {
      if (await picDir.exists() == true) {
        isWpInstall.value = true;

        getPicData();

        var androidInfo = await DeviceInfoPlugin().androidInfo;
        release = int.parse(androidInfo.version.release.toString());
        sdkInt = androidInfo.version.sdkInt ?? 0;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        print('Android $release (SDK $sdkInt), $manufacturer $model');
        // Android 9 (SDK 28), Xiaomi Redmi Note 7

        if (sdkInt < 30) {
          list.value = picDir
              .listSync(recursive: true)
              .map((item) => item.path)
              .toList(growable: false);
          print(list);
        } else {
          print("android 11 ");
        }

        list.value.forEach((element) async {
          if (element.endsWith("jpg")) {
          } else {
            if (element.endsWith("mp4")) {
              videolist.value.add(element);
            }
          }
        });
        storedlist.value = storDir
            .listSync(recursive: true)
            .map((e) => e.path.split("/").last)
            .where((element) {
          if (element.contains("_statussaver")) {
            return element.endsWith("jpg") || element.endsWith("mp4");
          } else {
            return false;
          }
        }).toList(growable: true);
        storedListall.value = storDir
            .listSync(recursive: true)
            .map((e) => e.path)
            .where((element) {
          if (element.contains("_statussaver")) {
            return element.endsWith("jpg") || element.endsWith("mp4");
          } else {
            return false;
          }
        }).toList(growable: true);
        if (list.length != 0) {
          isNoStatus.value = false;
          print(list);
          print(videolist);
          print('jhbcjbjhdvj${storedlist}');
          // print(storedImageList);

        } else {
          isNoStatus.value = true;
        }
      } else {
        isWpInstall.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ///
  ///[makeThumbnail] used to create each video's thumbnail
  ///
  Future<String> makeThumbnail(String path) async {
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 25,
    );
    return fileName!;
  }

  void saveFile(String string) async {
    CustomLoader.showLoader();
    try {
      final result = await ImageGallerySaver.saveFile(string,
          name: "${string.split("/").last.split(".").first}_statussaver");
      // CustomLoader.showMsgLoader(result.toString());
      print("==>>>>>>>>${string}");

      print("==>>>>>>>>${result}");
      CustomLoader.showMsgLoader("Sacved Succesfully");

      getData();
    } catch (e) {
      CustomLoader.showErrorLoader(e.toString());
    }
  }

  ///
  ///get all Data
  ///
  getData() {
    if (storedlist.isNotEmpty || storedListall.isNotEmpty) {
      storedlist.clear();
      storedListall.clear();
      storedlist.value = storDir
          .listSync(recursive: true)
          .map((e) => e.path.split("/").last)
          .where((element) {
        if (element.contains("_statussaver")) {
          return element.endsWith("jpg") || element.endsWith("mp4");
        } else {
          return false;
        }
      }).toList(growable: true);

      storedListall.value =
          storDir.listSync(recursive: true).map((e) => e.path).where((element) {
        if (element.contains("_statussaver")) {
          return element.endsWith("jpg") || element.endsWith("mp4");
        } else {
          return false;
        }
      }).toList(growable: true);
    } else {
      storedlist.value = storDir
          .listSync(recursive: true)
          .map((e) => e.path.split("/").last)
          .where((element) {
        if (element.contains("_statussaver")) {
          return element.endsWith("jpg") || element.endsWith("mp4");
        } else {
          return false;
        }
      }).toList(growable: true);

      storedListall.value =
          storDir.listSync(recursive: true).map((e) => e.path).where((element) {
        if (element.contains("_statussaver")) {
          return element.endsWith("jpg") || element.endsWith("mp4");
        } else {
          return false;
        }
      }).toList(growable: true);
    }

    print("hdvshvdvddjsvd->>>>>${storedlist}");
  }

  ///
  ///Delete File
  ///
  void deleteFile(String string) {
    CustomLoader.showLoader();
    try {
      File(string).delete().then((value) {
        CustomLoader.showMsgLoader("deelted Succes fully");
        getData();
      });
    } catch (e) {
      CustomLoader.showErrorLoader(e.toString());
    }
  }

  ///
  ///get PicData Only
  ///
  void getPicData() {
    if (imagelist.value.isNotEmpty) {
      imagelist.clear();
      list.forEach((element) {
        if (element.endsWith("jpg")) {
          imagelist.value.add(element);
        }
      });
    } else {
      list.forEach((element) {
        if (element.endsWith("jpg")) {
          imagelist.value.add(element);
        }
      });
    }
  }

  ///
  ///get only video Data
  ///
  void getVideoData() {
    if (videolist.value.isNotEmpty) {
      videolist.clear();
      list.forEach((element) {
        if (element.endsWith("mp4")) {
          videolist.value.add(element);
        }
      });
    } else {
      list.forEach((element) {
        if (element.endsWith("mp4")) {
          videolist.value.add(element);
        }
      });
    }
  }
}
