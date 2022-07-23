import 'dart:io';

import 'package:SiliconDownloader/pages/facebookscreen/facebook_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../component.dart';
import '../../loader/customloader.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/strings.dart';

class FaceBookscreen extends StatefulWidget {
  const FaceBookscreen({Key? key}) : super(key: key);

  @override
  State<FaceBookscreen> createState() => _FaceBookscreenState();
}

class _FaceBookscreenState extends State<FaceBookscreen> {
  FaceBookController con = Get.put<FaceBookController>(FaceBookController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (con.isInit.value == true) {
      con.chewieController.dispose();
      con.videoPlayerController.dispose();
    }
  }

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
        // margin: EdgeInsets.only(left: 5.5.w, right: 5.5.w),
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
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  CustomSizedBox.customHeightSizedBox(2.h),

                  MiddleContainer(child: Obx(() {
                    return con.isInit.value == true
                        ? Chewie(controller: con.chewieController)
                        : GlobalTextWidget(title: Strings.video_des);
                  })),

                  CustomSizedBox.customHeightSizedBox(2.h),

                  Obx(() {
                    return con.link.value.isNotEmpty
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
                                title: 'Download'),
                          )
                        : GlobalTextWidget(title: "");
                  }),
                  CustomSizedBox.customHeightSizedBox(3.h),

                  ///
                  ///
                  ///first Portion is finished
                  ///
                  ///

                  LastContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSizedBox.customHeightSizedBox(4.h),
                        GlobalTextWidget(
                          title: Strings.des1_1_facebook,
                          textstyle: Constant.des_inner_1_textstyle,
                        ),
                        CustomSizedBox.Sized1,
                        GlobalTextWidget(title: Strings.des1_2_facebook),
                        CustomSizedBox.Sized2,
                        GlobalTextWidget(
                            title:
                                "Note:- You can download Only videos and pictures of only publuic Account."),
                        CustomSizedBox.Sized3,
                        GlobalTextFormFiled(
                          controller: con.linkCon,
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
                                  if (con.linkCon.text.isNotEmpty) {
                                    bool isVaild =
                                        Uri.tryParse(con.linkCon.text)
                                                ?.hasAbsolutePath ??
                                            false;
                                    if (isVaild &&
                                        con.linkCon.text.contains("fb")) {
                                      // con.getDownloadLink(context);
                                      con.getDownloadLink(context);
                                    } else if (isVaild &&
                                        con.linkCon.text.contains("facebook")) {
                                      // con.getDownloadLinkOther();
                                      Get.snackbar("Error",
                                          "You can Download only public account videos and pictures ");
                                    } else {
                                      Get.snackbar("Error", "Link is Invalid");
                                    }
                                  } else {
                                    Get.snackbar("Error", "Link is Empty");
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
            ))
          ],
        ),
      ),
    );
  }
}
