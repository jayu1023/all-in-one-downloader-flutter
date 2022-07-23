import 'package:SiliconDownloader/appclass.dart';
import 'package:SiliconDownloader/commonmethods.dart';
import 'package:SiliconDownloader/pages/facebookscreen/facebookscreen.dart';
import 'package:SiliconDownloader/pages/instgramscreen/instagramscreen.dart';
import 'package:SiliconDownloader/pages/privacy_policy.dart';
import 'package:SiliconDownloader/pages/sharechatscreen/sharechatscreen.dart';
import 'package:SiliconDownloader/pages/whatsappscreen/whatsappscreen.dart';
import 'package:SiliconDownloader/pages/youtubescreen/youtubescreen.dart';
import 'package:SiliconDownloader/splash/splashscreen.dart';

import 'package:SiliconDownloader/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:sizer/sizer.dart';

import 'component.dart';
import 'controller/homecontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await GetStorage.init();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(Sizer(builder: (context, orientation, deviceType) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: SplashScreen(),
    );
  }));
}

class Myclass extends StatefulWidget {
  const Myclass({Key? key}) : super(key: key);

  @override
  State<Myclass> createState() => _MyclassState();
}

class _MyclassState extends State<Myclass> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const platformMethodChannel =
      const MethodChannel("heartbeat.fritz.ai/native");

  HomeController con = Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (con.ad != null) {
      con.showAdIfAvailable();
    }

    // con.checkconnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/myicon.jpg?alt=media&token=1fed355d-3b4f-4afd-8d89-50417142a829",
                height: 110.0,
                width: 110.0,
                placeholder: (context, child) {
                  return Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.0,
                      ));
                },
                useOldImageOnUrlChange: true,

                //  progressIndicatorBuilder: (context,x,download){
                //   return

                //   Text(download.downloaded.toString());

                //  },
                errorWidget: (context, x, error) {
                  return Icon(
                    Icons.signal_cellular_connected_no_internet_4_bar_outlined,
                    color: Colors.red,
                  );
                },
              ),
            ),
            ListTile(
                title: Text("Privacy Policy"),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {
                  con.loadOpenAd(PrivacyPolicy());
                }),
            ListTile(
              title: Text("Share Us"),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {},
            ),
            ListTile(
              title: Text("Rate Us"),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {},
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5.5.w, right: 5.5.w),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppBarIcon(
                bgColor: AppColors.backgroundColor,
                icon: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                  size: 20.0,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                  ////
                  ///OPEN DRAWEER
                  ///
                },
                shadowColor: AppColors.shadowColor,
              ),
              trailing: AppBarIcon(
                bgColor: AppColors.backgroundColor,
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20.0,
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 10.0,
                                width: MediaQuery.of(context).size.width / 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              Text("Fetures will be come soon!!!")
                            ],
                          ),
                        );
                      });
                },
                shadowColor: AppColors.shadowColor,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    "Choose Your \nUsefull Downloader",
                    style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  ListTileWidget(
                    onTap: () {
                      con.loadOpenAd(InstgramScreen());
                    },
                    imagePath:
                        "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/instagram.gif?alt=media&token=c7f6c734-04b6-4121-82d1-110ee063f70a",
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textColor,
                    ),
                  ),
                  ListTileWidget(
                    title: "FaceBook Downloader",
                    subtitle: "Paste link of Video and Download",
                    onTap: () {
                      con.loadOpenAd(FaceBookscreen());
                    },
                    imagePath:
                        "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/facebook.gif?alt=media&token=4a87776c-2ef6-4b97-8329-5ba9496066e8",
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textColor,
                    ),
                  ),
                  ListTileWidget(
                    title: "Youtube  Downloader",
                    imagePath:
                        "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/youtube.gif?alt=media&token=5e1c61d5-4a93-4d0c-b0c6-9bce2d467f13",
                    subtitle: "Paste link of Video and Download",
                    onTap: () {
                      con.loadOpenAd(YoutubeScreen());
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textColor,
                    ),
                  ),
                  ListTileWidget(
                    title: "ShareChat Downloader",
                    imagePath:
                        "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/sharechat.png?alt=media&token=8b0ad9e0-1032-42de-8a9c-60f08e30a907",
                    subtitle: "Paste link of Video and Download",
                    onTap: () {
                      con.loadOpenAd(SharchatScreen());
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textColor,
                    ),
                  ),
                  ListTileWidget(
                    title: "Whatsapp Downloader",
                    imagePath:
                        "https://firebasestorage.googleapis.com/v0/b/allinonedownloader-af409.appspot.com/o/whatsapp.gif?alt=media&token=79888ff1-af7a-4930-99b1-877d1b680321",
                    subtitle: "Download Status from your \n whatsapp",
                    onTap: () {
                      con.loadOpenAd(WhatsappScreen());
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textColor,
                    ),
                  )
                ],
              ),
            ),
            Obx(() {
              return con.isBannerAdReady.value == true &&
                      AppClass.isShowAd == true
                  ? Container(
                      width: con.bannerAd.size.width.toDouble(),
                      height: con.bannerAd.size.height.toDouble(),
                      child: AdWidget(
                        ad: con.bannerAd,
                      ),
                    )
                  : Container();
            })
          ],
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  String? imagePath, title, subtitle;
  Icon? trailing;
  void Function()? onTap;

  ListTileWidget(
      {Key? key,
      this.imagePath,
      this.title,
      this.subtitle,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 2.h, bottom: 2.h, left: 1.5.w, right: 1.5.w),
      child: InkWell(
        radius: 10.0,
        splashColor: Colors.grey.withOpacity(0.3),
        onTap: onTap ??
            () {
              CommonMethod.replaceAndJumpToNext(InstgramScreen());
            },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.sp),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.2),
                    blurRadius: 100.0,
                    spreadRadius: 0.00,
                    offset: Offset(0.0, 50.0))
              ]),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.center,
                height: 90.0,
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(30.sp)),
                padding: EdgeInsets.only(bottom: 2.h),
              ),
              Positioned(
                top: -30.0,
                left: 0.0,
                child: Row(
                  children: [
                    CachedNetworkImage(
                        imageUrl: imagePath!,
                        height: 110.0,
                        width: 110.0,
                        placeholder: (context, child) {
                          return Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: 50.0,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2.0,
                              ));
                        },
                        useOldImageOnUrlChange: true,
                        errorWidget: (context, x, error) {
                          return Icon(
                            Icons
                                .signal_cellular_connected_no_internet_4_bar_outlined,
                            color: Colors.red,
                          );
                        }),

                    //   Image.network(

                    //     imagePath ?? AppAssets.icInstagramGif,
                    //  loadingBuilder: (context, child, loadingProgress) => child,
                    //     height: 110.0,
                    //     width: 110.0,
                    //   ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(title ?? "InstaGram Downloader",
                            style: TextStyle(
                              fontSize: 13.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          subtitle ?? "Paste link of reel and  Download",
                          style: TextStyle(
                            fontSize: 9.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                      ],
                    ),
                    SizedBox(width: 1.5.w),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5.h,
                      ),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
