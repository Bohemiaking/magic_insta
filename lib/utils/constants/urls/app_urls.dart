import 'package:magic_insta/utils/constants/app_strings.dart';

class AppUrls {
  static String get baseUrl => 'https://api.apify.com/v2/acts/';
  static String get instagram =>
      '${baseUrl}apify~instagram-scraper/run-sync-get-dataset-items?token=${AppStrings.apifyToken}';
  static String get youtube => '${baseUrl}yt';
}
