import 'dart:io';

import 'package:SiliconDownloader/pages/whatsappscreen/whatsappscreen_controller.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/colors.dart';

class PhotoTabScreen extends StatefulWidget {
  const PhotoTabScreen({Key? key}) : super(key: key);

  @override
  State<PhotoTabScreen> createState() => _PhotoTabScreenState();
}

class _PhotoTabScreenState extends State<PhotoTabScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animCon;
  Animation<double>? animation;
  WhatsappScreen_controller con = Get.put(WhatsappScreen_controller());
  OverlayEntry? _popupDialog;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animCon = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 1.0, end: 0.0).animate(animCon!);

    con.isWpInstall.value == true && con.isNoStatus.value == false
        ? con.getPicData()
        : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animCon!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: Obx(() {
        return con.isWpInstall.value == true && con.isNoStatus.value == true
            ? Text("there is no status")
            : con.isWpInstall.value == false
                ? Center(child: Text("Please install Wahtasapp"))
                : con.imagelist.length != 0
                    ?
                    // With predefined options
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: LiveGrid.options(
                            primary: false,
                            shrinkWrap: true,
                            options: LiveOptions(
                                delay: Duration(milliseconds: 100),
                                visibleFraction: 0.9),

                            // Like GridView.builder, but also includes animation property

                            itemBuilder: (context, index, animate) {
                              return FadeTransition(
                                opacity:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animate,
                                    curve: Curves.bounceIn,
                                  ),
                                ),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(0.0, 0.5),
                                          end: Offset(0.0, 0.0))
                                      .animate(
                                    CurvedAnimation(
                                      parent: animate,
                                      curve: Curves.bounceOut,
                                    ),
                                  ),
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: GestureDetector(
                                      onLongPressEnd: (details) {
                                        _popupDialog!.remove();
                                      },
                                      onLongPress: () {
                                        _popupDialog = _createPopupDialog(
                                            con.imagelist.value[index]);

                                        Overlay.of(context)!
                                            .insert(_popupDialog!);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Positioned.fill(
                                              child: Image.file(
                                                File(
                                                    con.imagelist.value[index]),
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
                                                    bool isContains =
                                                        con.storedlist.contains(
                                                            "${con.imagelist[index].toString().split("/").last.split(".").first}_statussaver.${con.imagelist[index].toString().split("/").last.split(".").last}");

                                                    print(
                                                        "hjvsvdhd-->>${isContains}");

                                                    return Visibility(
                                                      visible: !isContains,
                                                      child: InkWell(
                                                        onTap: () {
                                                          con.saveFile(con
                                                              .imagelist[index]
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
                                                    onTap: () {
                                                      Share.shareFiles([
                                                        con.imagelist[index]
                                                      ], text: 'Share Image');
                                                    },
                                                    child: Icon(Icons.share,
                                                        color: AppColors
                                                            .backgroundColor),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },

                            // Other properties correspond to the `ListView.builder` / `ListView.separated` widget

                            itemCount: con.imagelist.value.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            )),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
      }),
    );
  }
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
              constraints: BoxConstraints(maxWidth: 90.w, maxHeight: 80.h),
              child: Image.file(
                File(url),
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );

///
///Animated Dialog[AnimatedDialog]
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
