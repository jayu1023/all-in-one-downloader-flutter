import 'package:external_path/external_path.dart';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../loader/customloader.dart';


class ShareScreenController extends GetxController {
  TextEditingController linkcon = TextEditingController();
  RxString convertedLink = "".obs;
  RxString originalLink="".obs;
  RxBool isInit = false.obs;
  VideoPlayerController? videoPlayerController;

  ChewieController? chewieController;
  static const platformMethodChannel =
      const MethodChannel("heartbeat.fritz.ai/native");
  static void registerCallBack11(
      String id, DownloadTaskStatus status, int progress) {
    // print("jhcdjhbggfrg@@@##67546578486%%%%%%%%%");
    // SendPort? sendPort = IsolateNameServer.lookupPortByName("port");
    // sendPort!.send([id, status, progress]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void saveFile() async {
    CustomLoader.showMsgLoader("Saving");
    try {
      var appDocDir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DCIM);
      String savePath = appDocDir;
      FlutterDownloader.registerCallback(registerCallBack11);

      final taskId = await FlutterDownloader.enqueue(
        url: originalLink.value,
        savedDir: savePath,
        fileName: DateTime.now().toString() + "_hcvdh" + ".mp4",
        saveInPublicStorage: true,
        requiresStorageNotLow: true,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    } catch (e) {
      Get.snackbar("Eroor", e.toString());
    }
  }

//https://sharechat.com/post/B0gqkARR?referrer=url
  void getDownloadLink(String link) async {
    try {
      final String result = await platformMethodChannel
          .invokeMethod("shareChatLink", {"hello": link});
      print("==>>${result}");
      if (result.isNotEmpty) {
        convertedLink.value ="${link}";
        originalLink.value=result.split("&").first;
        print("webview link=>>>${convertedLink.value}");
        print("original linkn ->>>${originalLink.value}");
    

        if (result.split("&").last.isNotEmpty) {
          isInit.value = true;
        }

        // chewieController.showControlsOnInitialize;

      } else {
        Get.snackbar("Eroor", "Failed to parse link");
      }
    } catch (e) {
      print(e);
      Get.snackbar("error", e.toString());
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    linkcon.dispose();
    if (isInit == true) {
      videoPlayerController!.dispose();
      chewieController!.dispose();
    }
    super.onClose();
  }

  void getLinkData(BuildContext context) async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

   if(data!=null){
linkcon.text = data.text!;
    }else{
      Get.snackbar("Eroor", "No data copied into clipboard");
    }
  }
}
