import 'dart:io';

import 'package:SiliconDownloader/pages/whatsappscreen/whatsappscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sizer/sizer.dart';

import '../../utils/colors.dart';



class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  WhatsappScreen_controller con = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(

        // toolbarHeight: 0.0,
        title: Text("Downloads",),
        
    
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        child: 
        
        
        Obx(
           () {
            return 
            con.storedListall.length!=0?
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.8),
                itemCount: con.storedListall.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Obx(() {
                          return Positioned.fill(
                            child: con.storedListall.value[index].endsWith(".mp4")
                                ? FutureBuilder(
                                    future: con.makeThumbnail(
                                        con.storedListall.value[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot != null) {
                                        return Image.file(
                                          File(
                                            snapshot.data.toString(),
                                          ),
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Text("error");
                                          },
                                        );
                                      } else {
                                        return snapshot.hasError
                                            ? Text("error")
                                            : Center(
                                                child: CircularProgressIndicator(),
                                              );
                                      }
                                    })
                                : con.storedListall.value[index].endsWith("jpg")
                                    ? Image.file(
                                        File(con.storedListall.value[index]),
                                        errorBuilder: (context, error, stackTrace) {
                                          return Text("error");
                                        },
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                          );
                        }),
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.textColor.withOpacity(0.4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  con.deleteFile(con.storedListall[index].toString());
                                },
                                child: Icon(Icons.delete,
                                    color: AppColors.backgroundColor),
                              ),
                              InkWell(

                                onTap: (){
                                  Share.shareFiles([con.storedListall[index]], text: 'Great picture');

                                },
                                child: Icon(Icons.share,
                                    color: AppColors.backgroundColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }):Center(
                  child: Text("There is no Downloaded Status"),
                );
          
          }
        ),
      ),
    );
  }
}
