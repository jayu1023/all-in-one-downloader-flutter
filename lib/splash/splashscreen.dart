import 'package:SiliconDownloader/component.dart';
import 'package:SiliconDownloader/controller/homecontroller.dart';
import 'package:SiliconDownloader/storage/Appkeys.dart';
import 'package:SiliconDownloader/storage/get_storage/getStorageClass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';


import '../intoductionscreen/IntroductionScreen.dart';
import '../main.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  HomeController con = Get.put(HomeController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      GetStorageClass().readData(AppKeys.IsVisited) as bool == true
          ? Get.off(Myclass())
          : Get.off(IntoductionPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        CachedNetworkImage(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/myicon.jpg?alt=media&token=1fed355d-3b4f-4afd-8d89-50417142a829',height: 110.0,width: 110.0,placeholder:(context,child){
                return Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.0,

                  ));
               } ,
               useOldImageOnUrlChange: true,
               ),
          SizedBox(
            height: 2.h,
          ),
          GlobalTextWidget(
           title:  "All in video Downloader",
            textstyle: TextStyle(color: AppColors.textColor, fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
