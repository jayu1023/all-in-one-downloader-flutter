import 'package:SiliconDownloader/utils/colors.dart';
import 'package:SiliconDownloader/utils/constant.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';


class AppBarIcon extends StatelessWidget {
  Icon? icon;
  Color? bgColor, shadowColor;
  void Function()? onTap;
  AppBarIcon({
    Key? key,
    this.icon,
    this.bgColor,
    this.shadowColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            print("App Iocn Tapped");
          },
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: bgColor ?? AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(8.sp),
            boxShadow: [
              BoxShadow(
                  blurRadius: 100.0,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(1.0, 0.5),
                  color: shadowColor ?? AppColors.shadowColor)
            ]),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child:
                icon ?? Icon(Icons.menu_open, color: Colors.black, size: 20.0)),
      ),
    );
  }
}

class GlobalTextFormFiled extends StatelessWidget {
  TextEditingController controller;
  InputBorder? inputBorder;
  Color? cursorColor, fillColor;
  bool? filled;

  GlobalTextFormFiled(
      {Key? key,
      required this.controller,
      this.cursorColor,
      this.fillColor,
      this.filled,
      this.inputBorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: cursorColor ?? AppColors.textColor,
      decoration: InputDecoration(
          enabledBorder: inputBorder ?? Constant.formFiledStyle,
          filled: filled ?? false,
          fillColor: fillColor ?? AppColors.shadowColor.withOpacity(0.2),
          border: inputBorder ?? Constant.formFiledStyle,
          focusedBorder: inputBorder ?? Constant.formFiledStyle,
          disabledBorder: inputBorder ?? Constant.formFiledStyle),
    );
  }
}

class GlobalTextWidget extends StatelessWidget {
  String title;
  TextStyle? textstyle;
  GlobalTextWidget({Key? key, this.textstyle, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textstyle,
    );
  }
}

class AppBarWidget extends StatelessWidget {
  String? title;
  Widget leadingIcon, trailingIcon;

  AppBarWidget(
      {Key? key,
      this.title,
      required this.leadingIcon,
      required this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: 5.5.w, right: 5.5.w),
        leading: leadingIcon,
        trailing: trailingIcon);
  }
}

class MiddleContainer extends StatelessWidget {
  Widget child;
  MiddleContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      width: Constant.videoPlayerSize.width,
      height: Constant.videoPlayerSize.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.sp),
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 50.0,
                color: AppColors.shadowColor,
                spreadRadius: 0.0,
                offset: Offset(0.0, 50.0))
          ]),
      child: child,
    );
  }
}

class LastContainer extends StatelessWidget {
  Widget child;
  LastContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 50 / 100,
      width: 100.w,
      padding: EdgeInsets.only(left: 5.5.w, right: 5.5.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp)),
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
                offset: Offset(5.0, 0.0),
                spreadRadius: 0.0,
                blurRadius: 20.0,
                color: AppColors.shadowColor)
          ]),
      child: child,
    );
  }
}

class GlobalButton extends StatelessWidget {
  void Function()? onTap;
  String? title;
  TextStyle? btnTextStyle;
  ButtonStyle? btnStyle;
  GlobalButton(
      {Key? key, this.onTap, this.title, this.btnTextStyle, this.btnStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: btnStyle ??
            ElevatedButton.styleFrom(
                primary: AppColors.backgroundColor,
                elevation: 10.0,
                onSurface: AppColors.textColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.sp))),
        onPressed: onTap ??
            () async {
              print("Global Button Tapedd!!");
            },
        child: Text(
          title ?? "Paste",
          style: btnTextStyle ?? TextStyle(color: AppColors.textColor),
        ));
  }
}
