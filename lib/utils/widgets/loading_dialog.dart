import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog {
  static show(BuildContext context) {
    return Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  CircularProgressIndicator.adaptive(),
                  //  CircularPercentIndicator(
                  //   radius: 40,
                  //   percent:
                  //       Get.find<DownloadControllerNew>()
                  //           .downloadProgress
                  //           .value,
                  //   progressColor: Theme.of(context).primaryColor,
                  //   center: Text(
                  //     '${(Get.find<DownloadControllerNew>().downloadProgress.value * 100).toStringAsFixed(0)}%',
                  //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                  Text(
                    'Saving....',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static hide() {
    Get.back();
  }
}
