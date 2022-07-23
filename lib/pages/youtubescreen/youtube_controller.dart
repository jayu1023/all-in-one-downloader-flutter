import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../loader/customloader.dart';

class YoutubeController extends GetxController {
  TextEditingController linkcon = TextEditingController();
  RxString link = "".obs;
  var streaminfo;
  RxBool isDownloading = false.obs;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  RxBool isInit = false.obs;
  ReceivePort _receivePort = ReceivePort();
  static void registerCallBack(
      String id, DownloadTaskStatus status, int progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("port");

    if (status == DownloadTaskStatus.enqueued) {
      // Get.snackbar("Message", "Dowanload started");

       print("message sent:::=>>${status.value}");
    } else {
      if (status == DownloadTaskStatus.complete) {
       
       print("message sent:::=>>${status.value}");

        // Get.snackbar("Message", "Download Completed");
      }
        sendPort!.send(status);
     
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // videoPlayerController!.pause();
    print(":::::Dispose");
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _receivePort.distinct();

    _receivePort.listen((message) {
      print(message);
      if (message as DownloadTaskStatus == DownloadTaskStatus.enqueued) {
          print("listen someee");
        // Get.snackbar("Message", "Dowanload started");
        
      } else {
          print("listen someee");

        // Get.snackbar("Message", "Download Completed");
      }
      // isDownloading.value = message as bool;
    });
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "port");
  }

  void saveFile() async {
    CustomLoader.showLoader();

    var appDocDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DCIM);
    String savePath = appDocDir;

    print(savePath);

    // // Open a file for writing.
    FlutterDownloader.registerCallback(registerCallBack);
    final taskId = await FlutterDownloader.enqueue(
      url: streaminfo.last.url.toString(),
      savedDir: savePath,
      fileName: DateTime.now().toString() + "_youtube" + ".mp4",
      saveInPublicStorage: true,
      requiresStorageNotLow: true,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    CustomLoader.dismissLoader();
  }

  void getDownloadLink(BuildContext context) async {
// Get highest quality muxed stream
    isDownloading.value = true;
    CustomLoader.showLoader();
    if (await Permission.storage.isDenied) {
      getPermission();
      CustomLoader.dismissLoader();
    } else {
      try {
        CustomLoader.showLoader();

        YoutubeExplode yt = YoutubeExplode();
//https://youtu.be/vLOLqtJu940
        StreamManifest manifest = await yt.videos.streamsClient.getManifest(
            linkcon.text.toString().split("/").last.endsWith('share') == false
                ? linkcon.text.toString().split("/").last
                : linkcon.text
                    .toString()
                    .split("?")[0]
                    .toString()
                    .split("/")
                    .last);
        print(
            "===>>>>>${linkcon.text.toString().split("/").last.endsWith('share') == false ? linkcon.text.toString().split("/").last : linkcon.text.toString().split("?")[0].toString().split("/").last}");
        var streamInfo = manifest.muxed;
        streaminfo = streamInfo;
        if (streamInfo != null) {
          // Get the actual stream
          print(streamInfo);

          var stream = yt.videos.streamsClient.get(streamInfo.last);
          link.value = streamInfo.last.url.toString();
          videoPlayerController =
              VideoPlayerController.network(streamInfo.last.url.toString());

          await videoPlayerController!.initialize();

          if (videoPlayerController!.value.isInitialized == true) {
            print("isvalue true");
            isInit.value = true;
          }
          chewieController = ChewieController(
              videoPlayerController: videoPlayerController!,
              allowFullScreen: true,
              autoPlay: false,
              looping: true,
              allowMuting: true,
              zoomAndPan: true);

          CustomLoader.dismissLoader();

          // Dio()
          //     .download(
          //   streamInfo.last.url.toString(),
          //   savePath,
          // )
          //     .then((value) {
          //   if (value.statusCode == 200) {
          //     CustomLoader.showSuccessLoader("downloaded");
          //   } else {
          //     CustomLoader.showErrorLoader(value.statusCode.toString());
          //   }
          // });
          // Pipe all the content of the stream into the file.

          // // Close the file.


        }
      } on SocketException catch (e) {
        e.printError();
        CustomLoader.dismissLoader();
      } catch (e) {
        CustomLoader.dismissLoader();

        e.printError();
      }
    }
  }

  void getPermission() {
    if (Permission.storage.request() == PermissionStatus.denied) {
      getPermission();
    }
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
