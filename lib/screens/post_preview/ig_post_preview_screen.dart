import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/download_controller.dart';
import 'package:magic_insta/controllers/fetch_posts_controller.dart';
import 'package:magic_insta/models/instagram_post_model.dart';
import 'package:magic_insta/utils/constants/app_enums.dart';
import 'package:magic_insta/utils/widgets/custom_snackbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class InstagramPostPreviewScreen extends StatefulWidget {
  final InstagramPostModel instagramPostModel;
  const InstagramPostPreviewScreen({
    super.key,
    required this.instagramPostModel,
  });

  @override
  State<InstagramPostPreviewScreen> createState() =>
      _InstagramPostPreviewScreenState();
}

class _InstagramPostPreviewScreenState
    extends State<InstagramPostPreviewScreen> {
  InstagramPostModel? post;
  PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  late ChewieController _chewieController;
  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = 0;
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _fetchPost();
    });

    super.initState();
  }

  _fetchPost() async {
    bool isVideoPost =
        widget.instagramPostModel.type == InstagramPostType.video;

    FetchPostsController fetchPostsController = Get.find();
    InstagramPostModel? instagramPostModel = await fetchPostsController
        .fetchInstagramPosts(
          context,
          widget.instagramPostModel.url!,
          videoUrl: isVideoPost ? widget.instagramPostModel.videoURL : null,
        );
    setState(() {
      post = instagramPostModel;
    });

    if (isVideoPost && post != null) {
      _initVideoPlayer();
    }
  }

  _initVideoPlayer() async {
    String? videorl = post!.videoURL;
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videorl!))
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          aspectRatio: _videoController!.value.aspectRatio,
          autoPlay: false,
          looping: true,
          autoInitialize: false,
          placeholder: Center(child: CircularProgressIndicator.adaptive()),
        );
        _chewieController.setVolume(0);
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (_videoController != null) {
      _videoController?.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FetchPostsController fetchPostsController = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Obx(
        () =>
            fetchPostsController.isLoading.isTrue
                ? Center(child: CircularProgressIndicator.adaptive())
                : post == null
                ? Center(child: Text('Something went wrong!'))
                : Column(
                  children: [
                    if (post!.type == InstagramPostType.video &&
                        _videoController!.value.isInitialized) ...[
                      _videoPreview(),
                    ] else if (post!.type == InstagramPostType.sidecar) ...[
                      _sidecarPreview(post!),
                    ] else ...[
                      _imagePreview(post!),
                    ],
                    _contentView(context, post!),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    _buttons(context, post!),
                  ],
                ),
      ),
    );
  }

  Widget _videoPreview() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }

  Widget _sidecarPreview(InstagramPostModel post) {
    return Expanded(
      child: SizedBox(
        // color: Colors.black,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: (post.dimensionsWidth! / post.dimensionsHeight!),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                children: [
                  for (ChildPost child in post.childPosts ?? [])
                    Image.network(
                      child.displayUrl!,
                      cacheWidth: child.dimensionsWidth,
                      cacheHeight: child.dimensionsHeight,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                ],
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: post.childPosts!.length,
                    effect: WormEffect(
                      dotWidth: 6,
                      dotHeight: 6,
                      activeDotColor: Colors.white,
                      dotColor: Theme.of(context).splashColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePreview(InstagramPostModel post) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: (post.dimensionsWidth! / post.dimensionsHeight!),
          child: Image.network(
            post.displayUrl!,
            cacheWidth: post.dimensionsWidth,
            cacheHeight: post.dimensionsHeight,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _contentView(BuildContext context, InstagramPostModel post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (post.caption == null || post.caption == '')
                    ? SizedBox.shrink()
                    : Text(
                      post.caption ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                Text(
                  "@${post.ownerUsername} ${post.ownerUsername != null ? "(${post.ownerFullName})" : ''}",
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              String text =
                  '${post.caption}\n@${post.ownerUsername} ${post.ownerUsername != null ? "(${post.ownerFullName})" : ''}';
              await Clipboard.setData(ClipboardData(text: text));
              if (context.mounted) {
                CustomSnackbar.showSnackBar(context, 'Copied!', isError: false);
              }
            },
            child: Icon(
              Icons.copy,
              size: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context, InstagramPostModel post) {
    DownloadController downloadControllerNew = Get.find();

    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                if (post.type == InstagramPostType.video) {
                  // video
                  downloadControllerNew.startDownload(
                    context,
                    post.videoURL!,
                    false,
                    post.id!,
                  );
                } else if (post.type == InstagramPostType.sidecar) {
                  // sidecar image
                  ChildPost child = post.childPosts![_currentPage];
                  downloadControllerNew.startDownload(
                    context,
                    child.displayUrl!,
                    true,
                    child.id!,
                  );
                } else if (post.type == InstagramPostType.singleImage) {
                  // single image
                  downloadControllerNew.startDownload(
                    context,
                    post.displayUrl ?? '',
                    true,
                    post.id ?? '',
                  );
                }
              },
              icon: Icon(
                Icons.file_download_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          if (post.type == InstagramPostType.sidecar) ...[
            Container(
              height: 19,
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  List<String> ids = [];
                  List<String> urls = [];
                  for (ChildPost child in post.childPosts ?? []) {
                    ids.add(child.id!);
                    urls.add(child.displayUrl!);
                  }
                  downloadControllerNew.startBatchDownload(
                    context,
                    urls,
                    true,
                    ids,
                  );
                },
                icon: Icon(
                  Icons.save_alt_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  'Save All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
