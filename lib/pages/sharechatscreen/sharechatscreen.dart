import 'dart:io';

import 'package:SiliconDownloader/pages/sharechatscreen/sharesScreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import '../../component.dart';
import '../../loader/customloader.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';




class SharchatScreen extends StatefulWidget {
  SharchatScreen({Key? key}) : super(key: key);

  @override
  State<SharchatScreen> createState() => _SharchatScreenState();
}

class _SharchatScreenState extends State<SharchatScreen> {
  final ShareScreenController con =
      Get.put<ShareScreenController>(ShareScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              AppBarWidget(
                  leadingIcon: AppBarIcon(
                    bgColor: AppColors.backgroundColor,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    onTap: () {
                      Get.back();
                      ////
                      ///OPEN DRAWEER
                      ///
                    },
                    shadowColor: AppColors.shadowColor,
                  ),
                  trailingIcon: AppBarIcon(
                    bgColor: AppColors.backgroundColor,
                    icon: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20.0,
                    ),
                    onTap: () {
                      ////
                      ///OPEN search bar
                      ///
                    },
                    shadowColor: AppColors.shadowColor,
                  )),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSizedBox.Sized2,
                    MiddleContainer(child: Obx(() {
                      return con.isInit.value == true
                          ? WebView(
                              initialUrl: con.convertedLink.value,
                              onPageStarted: (val) {
                                CustomLoader.showLoader();
                              },
                              onPageFinished: (value) {
                                CustomLoader.showMsgLoader(
                                    "Loaded Successfully");
                              },
                            )
                          : GlobalTextWidget(title: Strings.video_des);
                    })),
                    CustomSizedBox.Sized2,
                    Obx(() {
                      return con.convertedLink.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 30.w, right: 30.w),
                              child: GlobalButton(
                                btnStyle: ElevatedButton.styleFrom(
                                    primary: AppColors.backgroundColor,
                                    elevation: 10.0,
                                    onSurface: AppColors.textColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.sp))),
                                btnTextStyle:
                                    TextStyle(color: AppColors.textColor),
                                onTap: () {
                                  con.saveFile();
                                },
                                title: "Download",
                              ))
                          : GlobalTextWidget(title: "");
                    }),
                    CustomSizedBox.Sized3,
                    LastContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSizedBox.customHeightSizedBox(4.h),
                          GlobalTextWidget(
                            title: Strings.des1_1_sharchat,
                            textstyle: Constant.des_inner_1_textstyle,
                          ),
                          CustomSizedBox.Sized1,
                          GlobalTextWidget(title: Strings.des1_2_facebook),
                          CustomSizedBox.Sized3,
                          GlobalTextFormFiled(
                            controller: con.linkcon,
                            cursorColor: AppColors.textColor,
                            fillColor: AppColors.shadowColor.withOpacity(0.2),
                            filled: true,
                            inputBorder: Constant.formFiledStyle,
                          ),
                          CustomSizedBox.Sized1,
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GlobalButton(
                                  btnStyle: ElevatedButton.styleFrom(
                                      primary: AppColors.backgroundColor,
                                      elevation: 10.0,
                                      onSurface: AppColors.textColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.sp))),
                                  btnTextStyle:
                                      TextStyle(color: AppColors.textColor),
                                  onTap: () async {
                                    if (con.linkcon.text.isNotEmpty) {
                                      bool isvalid =
                                          Uri.tryParse(con.linkcon.text)
                                                  ?.hasAbsolutePath ??
                                              false;
                                      if (isvalid &&
                                          con.linkcon.text
                                              .contains("sharechat.com")) {
                                        con.getDownloadLink(con.linkcon.text);
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Link is Invalid",
                                        );
                                      }
                                    } else {
                                      Get.snackbar("Error", "Link is empty");
                                    }
                                  },
                                  title: "Convert",
                                ),
                                GlobalButton(
                                  btnStyle: Constant.elevatedButtonStyle,
                                  onTap: () async {
                                    con.getLinkData(context);
                                  },
                                  btnTextStyle:
                                      TextStyle(color: AppColors.textColor),
                                  title: "Paste",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (con.isInit.value == true) {
      con.chewieController!.dispose();
      con.videoPlayerController!.dispose();
    }
  }
}
