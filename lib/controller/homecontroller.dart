import 'dart:async';

import 'package:SiliconDownloader/commonmethods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ad_helper.dart';
import '../appclass.dart';
import '../main.dart';
import '../pages/nointernetscreen.dart';

class HomeController extends GetxController {
  StreamSubscription? subscription;
  late BannerAd bannerAd;
  AppOpenAd? ad;
  bool _isShowingAd = false;

  RxBool isBannerAdReady = false.obs;
  @override
  void onInit() {
    super.onInit();

    //check connectivity

    checkconnectivity();

    //load open ad
    // loadOpenAd();

    //subscribe for connectivity change listenere
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);

      if (result == ConnectivityResult.none) {
        Get.off(NoInternetScreen());
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (AppClass.isShowAd == true) {
          loadAd();
        }

        Get.off(Myclass());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    subscription!.cancel();
  }

  void checkconnectivity() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      Get.off(NoInternetScreen());
    }
  }

  bool get isAdAvailable {
    return ad == null ? true : false;
  }

  ///
  ///load open Appopen ad
  ///
  void loadOpenAd(Widget screen) {
    AppOpenAd.load(
      adUnitId: AdHelper.appOpenAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(nonPersonalizedAds: false),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          ad = ad;
          if (ad != null) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _isShowingAd = true;
                print('$ad onAdShowedFullScreenContent');
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                _isShowingAd = false;
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                print('$ad onAdDismissedFullScreenContent');
                _isShowingAd = false;
                CommonMethod.replaceAndJumpToNext(screen);
                ad.dispose();

                // loadOpenAd();
              },
            );
            ad.show();
            print("=-?>>>>>>>>>> ad is got");
          } else {
            CommonMethod.replaceAndJumpToNext(screen);
          }

          // showAdIfAvailable();
        },
        onAdFailedToLoad: (error) {
          ad!.dispose();
          CommonMethod.replaceAndJumpToNext(screen);
          print("=-?>>>>>>>>>> ${error.toString()}");
          // Handle the error.
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      // loadOpenAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (ad != null) {
      print("ad is null");
      ad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
          print('$ad onAdShowedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          _isShowingAd = false;
          ad.dispose();
        },
        onAdDismissedFullScreenContent: (ad) {
          print('$ad onAdDismissedFullScreenContent');
          _isShowingAd = false;

          ad.dispose();

          // loadOpenAd();
        },
      );
      ad!.show();
    }
    // Set the fullScreenContentCallback and show the ad.
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bannerAd.dispose();
  }

  void loadAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady.value = false;

          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }
}
