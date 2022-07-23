import 'package:SiliconDownloader/pages/whatsappscreen/tabscreen/phototab_screen.dart';
import 'package:SiliconDownloader/pages/whatsappscreen/tabscreen/videostab_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sizer/sizer.dart';
import '../../component.dart';


import '../../utils/colors.dart';
import 'Downloadscreen.dart';


class WhatsappScreen extends StatefulWidget {
  const WhatsappScreen({Key? key}) : super(key: key);

  @override
  State<WhatsappScreen> createState() => _WhatsappScreenState();
}

class _WhatsappScreenState extends State<WhatsappScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animcon;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 160.0,
                pinned: true,
                centerTitle: true,
                title: Text(
                  "Whatsapp Status Saver",
                  style: TextStyle(color: AppColors.textColor, fontSize: 12.sp),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.backgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  background: Opacity(
                    opacity: 0.1,
                    child: CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/whatsapp.gif?alt=media&token=79888ff1-af7a-4930-99b1-877d1b680321",height: 110.0,width: 110.0,placeholder:(context,child){
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
                  ),
                ),
                shadowColor: AppColors.backgroundColor,
                elevation: 20.0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBarIcon(
                    bgColor: AppColors.backgroundColor,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      Get.back();
                    },
                    shadowColor: AppColors.shadowColor,
                  ),
                ),
                bottom: PreferredSize(
                    child: Container(
                      padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w),
                      margin: EdgeInsets.only(
                          right: 1.5.w, left: 1.5.w, bottom: 1.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.textColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: TabBar(
                          automaticIndicatorColorAdjustment: true,
                          indicatorColor: Colors.black,
                          unselectedLabelColor: AppColors.textColor,
                          labelStyle:
                              TextStyle(color: AppColors.backgroundColor),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.sp),
                              color: AppColors.textColor,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.shadowColor.withOpacity(0.3))
                              ]),
                          tabs: [
                            Tab(
                              text: "Photos",
                            ),
                            Tab(
                              text: "Videos",
                            )
                          ]),
                    ),
                    preferredSize: Size(100.w, 10.h)),
              )
            ];
          },
          body: TabBarView(

            children: [PhotoTabScreen(), VideoTabScreen()],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(DownloadScreen());
        },
        backgroundColor: Colors.greenAccent,
        label: Row(
          children: [
            Icon(
              Icons.download,
              color: AppColors.backgroundColor,
            ),
            Text("Downloads")
          ],
        ),
      ),
    );
  }
}
