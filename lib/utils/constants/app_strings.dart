import 'dart:io';

class AppStrings {
  static String get appName => 'NetSave';
  static String get apifyToken =>
      'apify_api_kbVCzcgewtzDOpIo9WdkQbTfTQ7WST44gg1w';
  static String get unityGameID => Platform.isAndroid ? '5830253' : '5830252';
  static String get unityInterstitialAd =>
      Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS';
  static String get unityRewardedAd =>
      Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS';
  static String get unityBannerAd =>
      Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';
}
