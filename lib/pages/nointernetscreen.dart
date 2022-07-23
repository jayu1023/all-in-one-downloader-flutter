import 'package:SiliconDownloader/utils/appassets.dart';
import 'package:SiliconDownloader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class NoInternetScreen extends StatefulWidget {
  NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.icNoInternetPic,
              width: 80.w,
              height: 30.h,
            ),
            Text(
              "No Internet!! \n Please Turn On Internet",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
