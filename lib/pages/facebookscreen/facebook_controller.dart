import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:direct_link/direct_link.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../component.dart';
import '../../loader/customloader.dart';

class FaceBookController extends GetxController {
  TextEditingController linkCon = TextEditingController();
  RxString link = "".obs;
  RxBool isDownloading = false.obs;
  RxBool isInit = false.obs;
  List<SiteModel>? check = [];
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;

  static const platformMethodChannel =
      const MethodChannel("heartbeat.fritz.ai/native");
  ReceivePort _receivePort = ReceivePort();

  static void registerCallBack(
      String id, DownloadTaskStatus status, int progress) {
    if (status == DownloadTaskStatus.running) {
      Get.snackbar("Message", "Download started");
    } else {
      if (status == DownloadTaskStatus.complete) {
        Get.snackbar("Message", "Download Completed");
      }
    }
    SendPort? sendPort = IsolateNameServer.lookupPortByName("port");
    sendPort!.send([id, status, progress]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _receivePort.distinct();

    _receivePort.listen((message) {
      print("==>>>>>>4544@#760868977%^&&${message}");
      if (message[1] == DownloadTaskStatus.running) {
        // Get.snackbar("Download", "Downloading Started");
      } else if (message[1] == DownloadTaskStatus.complete) {
        Get.snackbar("Success", "downloading Complete");
        CustomLoader.dismissLoader();
      } else if (message[1] == DownloadTaskStatus.failed) {
        Get.snackbar("Eroor", "downloading Faild");
      }
      isDownloading.value = message as bool;
    });
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "port");
  }

  void saveFile() async {
    var appDocDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DCIM);
    String savePath = appDocDir;
    FlutterDownloader.registerCallback(registerCallBack);

    final taskId = await FlutterDownloader.enqueue(
      url: link.value,

      savedDir: savePath,

      fileName: DateTime.now().toString() + ".mp4",
      saveInPublicStorage: true,
      requiresStorageNotLow: true,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  void getDownloadLink(BuildContext context) async {
    CustomLoader.showLoader();
    try {
      // Document doc = parse(linkCon.text);
      // final String result =
      //     doc.head!.getElementsByTagName("meta").last.toString();
      // final String result = await platformMethodChannel
      //     .invokeMethod("facebookLink", {"hello": linkCon.text});
      final List<SiteModel> result = await DirectLink.check(linkCon.text) ?? [];

      if (result.length != 0) {
        link.value = result[0].link;
        print(result);
      }
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

      // Get.snackbar("Success", "");
    } on NoSuchMethodError catch (e) {
      Get.snackbar("eroor", e.toString());

      CustomLoader.dismissLoader();
    } on PlatformException catch (e) {
      e.printError();
      Get.snackbar(e.code, e.message.toString());
      CustomLoader.dismissLoader();

      // getDownloadLinkOther();
    } catch (e) {
      Get.snackbar("Eroor", e.toString());
      CustomLoader.dismissLoader();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        CustomLoader.dismissLoader();
      });
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    linkCon.dispose();
    if (isInit.value == true) {
      // videoPlayerController.dispose();
      // chewieController.dispose();
    }
    super.onClose();
  }

  void getDownloadLinkOther() async {
    CustomLoader.showLoader();
    try {
      check = await DirectLink.check(linkCon.text) ?? []; // add your url
      if (check!.length != 0) {
        link.value = check![check!.length - 1].link;
      } else {
        Get.snackbar("Message", "No Video Fetched");
      }
      print(check);

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
    } catch (e) {
      CustomLoader.dismissLoader();
    }
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
