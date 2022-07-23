import 'dart:io';

import 'package:SiliconDownloader/pages/instgramscreen/instagram_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../component.dart';

import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';


class InstgramScreen extends StatefulWidget {
  const InstgramScreen({Key? key}) : super(key: key);

  @override
  State<InstgramScreen> createState() => _InstgramScreenState();
}

class _InstgramScreenState extends State<InstgramScreen> {
  InstagramController con = Get.put<InstagramController>(InstagramController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

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
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  CustomSizedBox.customHeightSizedBox(2.h),

                  MiddleContainer(child: Obx(() {
                    return con.isInit.value == true
                        ? Chewie(controller: con.chewieController,
                              

                        )
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
                          title: Strings.des1_1_insta,
                          textstyle: Constant.des_inner_1_textstyle,
                        ),
                        CustomSizedBox.Sized1,
                        GlobalTextWidget(title: Strings.des1_2_insta),
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
                                    bool isvalid =
                                        Uri.tryParse(con.linkCon.text)
                                                ?.hasAbsolutePath ??
                                            false;
                                    if (isvalid &&
                                        con.linkCon.text
                                            .contains("instagram.com")) {
                                      con.getDownloadLink(context);
                                    } else {
                                      Get.snackbar("Error", "link is invalid");
                                    }
                                  } else {
                                    Get.snackbar("Error", "link is empty");
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
      ),
    );
  }
}
