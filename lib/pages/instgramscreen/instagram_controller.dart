import 'dart:isolate';

import 'package:chewie/chewie.dart';
import 'package:external_path/external_path.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import 'package:video_player/video_player.dart';
import 'package:direct_link/direct_link.dart';

import '../../component.dart';
import '../../loader/customloader.dart';

class InstagramController extends GetxController {
  TextEditingController linkCon = TextEditingController();
  late ChewieController chewieController;
  RxString link = "".obs;
  List<SiteModel>? check = [];
  RxBool isInit = false.obs;
  ReceivePort _receivePort = ReceivePort();
  late VideoPlayerController videoPlayerController;

  static const platformMethodChannel =
      const MethodChannel("heartbeat.fritz.ai/native");

  static void registerCallBack1(
      String id, DownloadTaskStatus status, int progress) {}

  @override
  void onInit() {
    super.onInit();
  }

  void saveFile() async {
    CustomLoader.showMsgLoader("Saving");
    try {
      var appDocDir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DCIM);
      String savePath = appDocDir;
      FlutterDownloader.registerCallback(registerCallBack1);

      final taskId = await FlutterDownloader.enqueue(
        url: link.value,
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

  void getDownloadLink(BuildContext context) async {
    CustomLoader.showLoader();
    try {
      check = await DirectLink.check(linkCon.text) ?? []; // add your url

      print(check);
      if (check!.length != 0) {
        print("jkbhfgkbgfg${link.value}");
        link.value = check![check!.length - 1].link;
        videoPlayerController = VideoPlayerController.network(link.value);
        videoPlayerController.initialize();
        if (videoPlayerController != null) {
          isInit.value = true;
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            allowFullScreen: true,
            allowPlaybackSpeedChanging: true,

            overlay: Container(
              color: Colors.transparent,
            ),
            // aspectRatio: 16 / 9,

            zoomAndPan: true,
            materialProgressColors: ChewieProgressColors(
                bufferedColor: Colors.transparent,
                handleColor: Colors.white,
                playedColor: Colors.blue),
            errorBuilder: (context, x) {
              return GlobalTextWidget(title: "no Video Fetched");
            },
            looping: true,
          );
          if (videoPlayerController.value.isInitialized == true) {
            isInit.value = true;
            CustomLoader.dismissLoader();
          }
        }
      } else {
        EasyLoading.showToast("Can not get link",
            duration: Duration(milliseconds: 500));
        print("out of screen");
      }
    } catch (e) {
      print(e);
      EasyLoading.showError(e.toString());
    } finally {
      // EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    // linkCon.dispose();
    if (isInit.value == true) {
      // videoPlayerController.dispose();
      // chewieController.dispose();
    }
    super.onClose();
  }

  void getLinkData(BuildContext context) async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      linkCon.text = data.text!;
    } else {
      Get.snackbar("Eroor", "No data copied into clipboard");
    }
  }
}
