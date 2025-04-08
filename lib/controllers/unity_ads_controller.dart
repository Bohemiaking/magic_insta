import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:magic_insta/utils/constants/app_strings.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsController extends GetxController {
  @override
  void onInit() {
    loadInterstitialAd();
    super.onInit();
  }

  Future<void> loadInterstitialAd() async {
    await UnityAds.load(
      placementId: AppStrings.unityInterstitialAd,
      onComplete: (placementId) async {},
      onFailed:
          (placementId, error, message) =>
              print('Load Failed $placementId: $error $message'),
    );
  }

  Future<void> showInterstitialAd() async {
    final completer = Completer<void>();

    await UnityAds.showVideoAd(
      placementId: AppStrings.unityInterstitialAd,
      onStart: (placementId) => print('Ad started: $placementId'),
      onClick: (placementId) => loadInterstitialAd(),
      onSkipped: (placementId) async {
        await loadInterstitialAd();
        if (!completer.isCompleted) completer.complete(); // resume flow
      },
      onComplete: (placementId) async {
        await loadInterstitialAd();
        if (!completer.isCompleted) completer.complete(); // resume flow
      },
      onFailed: (placementId, error, message) async {
        await loadInterstitialAd();
        if (!completer.isCompleted) completer.complete(); // resume flow
      },
    );

    return completer.future;
  }
}
