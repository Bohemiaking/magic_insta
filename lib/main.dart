import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/auth_controller.dart';
import 'package:magic_insta/controllers/download_controller.dart';
import 'package:magic_insta/controllers/fetch_posts_controller.dart';
import 'package:magic_insta/controllers/unity_ads_controller.dart';
import 'package:magic_insta/firebase_options.dart';
import 'package:magic_insta/screens/home/home_screen.dart';
import 'package:magic_insta/utils/constants/app_strings.dart';
import 'package:magic_insta/utils/theme/app_theme.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UnityAds.init(gameId: AppStrings.unityGameID, testMode: false);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.purpleM3,
        textTheme: AppTheme.textTheme,
      ).copyWith(
        primaryColor: AppTheme.primararyColor,
        dividerColor: Colors.grey.shade300,
        inputDecorationTheme: AppTheme.inputDecorationTheme,
        brightness: Brightness.light,
        chipTheme: AppTheme.chipTheme,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.purpleM3,
        textTheme: AppTheme.textTheme,
      ).copyWith(
        inputDecorationTheme: AppTheme.inputDecorationTheme,
        brightness: Brightness.dark,
        chipTheme: AppTheme.chipTheme,
      ),
      themeMode: ThemeMode.light,
      initialBinding: AppBindings(),
      home: Scaffold(body: HomeScreen()),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(FetchPostsController());
    Get.put(UnityAdsController());
    Get.put(DownloadController());
  }
}
