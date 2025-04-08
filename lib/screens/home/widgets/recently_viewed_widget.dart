import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/fetch_posts_controller.dart';
import 'package:magic_insta/models/instagram_post_model.dart';
import 'package:magic_insta/screens/post_preview/ig_post_preview_screen.dart';
import 'package:magic_insta/utils/constants/app_enums.dart';

class RecentlyViewedWidget extends StatelessWidget {
  const RecentlyViewedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPostsController fetchPostsController = Get.find();

    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 8,
          children: [
            Text(
              'Recently Viewed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (fetchPostsController.isLoadingHistory.isTrue &&
                fetchPostsController.history.isEmpty) ...[
              Center(child: CircularProgressIndicator.adaptive()),
            ] else if (fetchPostsController.history.isEmpty) ...[
              Text('No recent posts to view!'),
            ] else ...[
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.7,
                ),
                itemCount: fetchPostsController.history.take(9).length,
                itemBuilder: (context, index) {
                  InstagramPostModel post = fetchPostsController.history[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        InstagramPostPreviewScreen(instagramPostModel: post),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            post.displayUrl ?? '',
                            fit: BoxFit.cover,
                            cacheWidth: post.dimensionsWidth,
                            cacheHeight: post.dimensionsHeight,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child:
                                post.type == InstagramPostType.sidecar
                                    ? Icon(
                                      Icons.copy_rounded,
                                      size: 17,
                                      color: Colors.grey.shade50,
                                    )
                                    : post.type == InstagramPostType.video
                                    ? Icon(
                                      Icons.videocam,
                                      size: 17,
                                      color: Colors.grey.shade50,
                                    )
                                    : SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              OutlinedButton(onPressed: () {}, child: Text('View all')),
            ],
          ],
        ),
      ),
    );
  }
}
