import 'dart:io';

import 'package:SiliconDownloader/pages/whatsappscreen/whatsappscreen_controller.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';


import '../../../utils/colors.dart';

class VideoTabScreen extends StatefulWidget {
  const VideoTabScreen({Key? key}) : super(key: key);

  @override
  State<VideoTabScreen> createState() => _VideoTabScreenState();
}

class _VideoTabScreenState extends State<VideoTabScreen> with SingleTickerProviderStateMixin {
  WhatsappScreen_controller con = Get.put(WhatsappScreen_controller());
  OverlayEntry? dialog;
  ChewieController? _chewieController;
  AnimationController? animcon;
  Animation<double>? animation;
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    animcon=AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    animation=Tween<double>(begin: 0.0,end: 1.0).animate(animcon!);
    con.isNoStatus.value == false && con.isWpInstall.value == true
        ? con.getVideoData()
        : null;
  }@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animcon!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: Obx(() {
        return con.isWpInstall.value == true && con.isNoStatus.value == true
            ? Center(child: Text("there is no status"))
            : con.isWpInstall.value == false
                ? Center(child: Text("Please install Wahtasapp"))
                : con.videolist.length != 0


                    ?
                    
                    LiveGrid.options(itemBuilder: (context,index,animate){


                      return  FadeTransition(
                        opacity: Tween<double>(begin: 0.0,end: 1.0).animate(animate),
                        child: SlideTransition(
                          position: Tween<Offset>(begin: Offset(0.0,0.5),end: Offset(0.0,0.0)).animate(CurvedAnimation(parent: animate, curve: Curves.bounceIn)),
                          child: FutureBuilder(
                            
                                future:
                                    con.makeThumbnail(con.videolist.value[index]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return snapshot.data != null
                                      ? Card(
                                        elevation: 15.0,
                                        clipBehavior: Clip.none,
                                        borderOnForeground: false,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          onLongPress: () async {
                                            _videoPlayerController =
                                                VideoPlayerController.file(File(
                                                    con.videolist.value[index]));
                                            await _videoPlayerController!
                                                .initialize();
                        
                                            if (_videoPlayerController != null) {
                                              _chewieController =
                                                  ChewieController(
                                                      videoPlayerController:
                                                          _videoPlayerController!,
                                                      autoPlay: true,
                                                      showOptions: false,
                                                      allowFullScreen: false,
                                                      allowPlaybackSpeedChanging:
                                                          false,
                                                      showControls: true);
                        
                                              dialog = _createPopupDialog(
                                                  con.videolist.value[index]);
                                              Overlay.of(context)!
                                                  .insert(dialog!);
                                            }
                                          },
                                          onLongPressEnd: (details) {
                                            if (Overlay != null) {
                                              dialog!.remove();
                                            }
                        
                                            _videoPlayerController!.pause();
                                          },
                                          child: Stack(
                        
                                            fit: StackFit.loose,
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Positioned.fill(
                        
                                                child: Image.file(
                                                  File(snapshot.data),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColors.textColor
                                                          .withOpacity(0.4)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Obx(() {
                                                        bool isContains = con
                                                            .storedlist
                                                            .contains(
                                                                "${con.videolist[index].toString().split("/").last.split(".").first}_statussaver.${con.videolist[index].toString().split("/").last.split(".").last}");
                                                        print(
                                                            "hjvsvdhd Video-->>${isContains}");
                                                        return Visibility(
                                                          visible: !isContains,
                                                          child: InkWell(
                                                            onTap: () {
                                                              File f1=File(con.videolist[index].toString());
                                                              // f1.rename("${con.videolist[index].toString().split("/").last.split(".").first}_statussaver");
                                                              f1.copy('/storage/emulated/0/Pictures/${con.videolist[index].toString().split("/").last.split(".").first}_statussaver.${con.videolist[index].toString().split("/").last.split(".").last}').then((value) {
                                                                if(value!=null){
                                                                  EasyLoading.showInfo("Saved");
                                                                }else{
                                                                  EasyLoading.showInfo("something worng");
                                                                }
                                                              });
                                                              con.getData();
                                                              con.saveFile(con
                                                                  .videolist[
                                                                      index]
                                                                  .toString());

                                                            },
                                                            child: Icon(
                                                                Icons.download,
                                                                color: AppColors
                                                                    .backgroundColor),
                                                          ),
                                                        );
                                                      }),
                                                      InkWell(
                                                        onTap: (){
                                                            Share.shareFiles([con.videolist[index]], text: 'Share  Video');

                                                        },
                                                        child: Icon(Icons.share,
                                                            color: AppColors
                                                                .backgroundColor),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )
                                      : Center(child: CircularProgressIndicator());
                                },
                              ),
                        ),
                      );
                    }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ), itemCount: con.videolist.length, options: LiveOptions(
                                delay: Duration(milliseconds: 100),
                                visibleFraction: 0.9)):Center(child: CircularProgressIndicator(),);
                    
                    
      }),
    );
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPopupContent(String url) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80.h,
                width: 100.w,
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            ],
          ),
        ),
      );
}

///
///Effect for popuo box
///
class AnimatedDialog extends StatefulWidget {
  Widget child;
  AnimatedDialog({Key? key, required this.child}) : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? opacityAnimation;
  Animation<double>? scaleAnimation;

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller!, curve: Curves.easeOutExpo));

    controller!.addListener(() => setState(() {}));
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation!.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation!,
          child: ScaleTransition(
            scale: scaleAnimation!,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
