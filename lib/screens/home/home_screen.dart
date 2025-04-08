import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/auth_controller.dart';
import 'package:magic_insta/controllers/fetch_posts_controller.dart';
import 'package:magic_insta/models/instagram_post_model.dart';
import 'package:magic_insta/screens/post_preview/ig_post_preview_screen.dart';
import 'package:magic_insta/screens/home/widgets/recently_viewed_widget.dart';
import 'package:magic_insta/utils/constants/app_strings.dart';
import 'package:magic_insta/utils/theme/app_theme.dart';
import 'package:magic_insta/utils/widgets/custom_snackbar.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> fetchedUrls = [];

  Future<void> _retrieveCopiedText() async {
    FetchPostsController fetchPostsController = Get.find();
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null && data.text != null && mounted) {
      final String copiedText = data.text!.trim();

      // Check if it's a valid URL
      final Uri? uri = Uri.tryParse(copiedText);
      final bool isValidUrl =
          uri != null &&
          (uri.isScheme('http') || uri.isScheme('https')) &&
          uri.host.isNotEmpty;

      if (isValidUrl) {
        InstagramPostModel? post = await fetchPostsController
            .fetchInstagramPosts(context, copiedText);
        if (post != null) {
          Get.to(InstagramPostPreviewScreen(instagramPostModel: post));
        }
      } else {
        CustomSnackbar.showSnackBar(context, 'Paste valid link!');
      }
    }
  }

  @override
  void initState() {
    AuthController authController = Get.find();
    FetchPostsController fetchPostsController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      if (authController.isLoggedIn.isFalse) {
        await authController.signInWithGoogle();
      }
      fetchPostsController.fetchUserHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FetchPostsController fetchPostsController = Get.find();
    AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap:
                    fetchPostsController.isLoading.isTrue
                        ? null
                        : () async {
                          if (authController.isLoggedIn.isFalse) {
                            await authController.signInWithGoogle();
                            return;
                          }
                          _retrieveCopiedText();
                        },

                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primararyGradientColors[0].withValues(
                          alpha: 0.5,
                        ),
                        AppTheme.primararyGradientColors[1].withValues(
                          alpha: 0.5,
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fetchPostsController.isLoading.isTrue
                          ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                          : Text(
                            'Tap here to paste link',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Center(
              child: UnityBannerAd(
                placementId: AppStrings.unityBannerAd,
                size: BannerSize.iabStandard,
              ),
            ),
            RecentlyViewedWidget(),
          ],
        ),
      ),
    );
  }
}
