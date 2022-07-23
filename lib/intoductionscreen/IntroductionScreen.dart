import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:introduction_screen/introduction_screen.dart';


import '../main.dart';
import '../storage/Appkeys.dart';
import '../storage/get_storage/getStorageClass.dart';

class IntoductionPage extends StatefulWidget {
  const IntoductionPage({Key? key}) : super(key: key);

  @override
  State<IntoductionPage> createState() => _IntoductionPageState();
}

class _IntoductionPageState extends State<IntoductionPage> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      
      isProgress: true,
      next: ElevatedButton(
        onPressed: () {},
        child: Text("Next"),
      ),
      done: ElevatedButton(
        onPressed: () {
          GetStorageClass().writeData(AppKeys.IsVisited, true);
          Get.off(Myclass());
        },
        child: Text("Done"),
      ),
      showDoneButton: true,
      showNextButton: true,
      onDone: () {


      },
      pages: [
        PageViewModel(
          title: "First Step:- Download Any Video You Want",
          body:
              "First Step. Choose your usefull downloader like Instagram ,you tube downloader etc..",
          image: Center(
            child: Text("first image"),
          ),
        ),
        PageViewModel(
          title: "Second Step :- Copy Paste",
          body:
              "Second Step. Copy link of your desired video from desired platform then come here and paste it into field then  press convert ",
          image: Center(
            child: Text("second image"),
          ),
        ),
        PageViewModel(
          title: "Third Step :- Download Your video",
          body:
              "Third Step. Wait while your video is loading....after then download it from download button ",
          image: Center(
            child: Text("third image"),
          ),
        )
      ],
    );
  }
}
