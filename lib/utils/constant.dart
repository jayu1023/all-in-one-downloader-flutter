import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';


class Constant {
  static final Size videoPlayerSize = Size(80.w, 35.h);
  static final TextStyle des_inner_1_textstyle =
      TextStyle(color: AppColors.textColor, fontSize: 15.sp);
  static final InputBorder formFiledStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.sp),
      borderSide: BorderSide(
          style: BorderStyle.none, color: Colors.transparent, width: 0.0));

  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      primary: AppColors.backgroundColor,
      elevation: 10.0,
      onSurface: AppColors.textColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)));
}

class CustomSizedBox {
  static final SizedBox Sized1 = SizedBox(height: 1.h);
  static final SizedBox Sized2 = SizedBox(height: 2.h);
  static final SizedBox Sized3 = SizedBox(height: 3.h);
  static Widget customWidthSizedBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  static Widget customHeightSizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget customSizedBox(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
