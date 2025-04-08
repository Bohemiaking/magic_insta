import 'dart:io';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/unity_ads_controller.dart';
import 'package:magic_insta/utils/constants/app_strings.dart';
import 'package:magic_insta/utils/helpers/helpers.dart';
import 'package:magic_insta/utils/widgets/loading_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  // RxDouble downloadProgress = 0.0.obs;

  @override
  void onInit() {
    FileDownloader().updates.listen((update) async {
      switch (update) {
        case TaskStatusUpdate():
          switch (update.status) {
            case TaskStatus.complete:
              String filePath =
                  '${update.task.directory}/${update.task.filename}';
              // String fileName = update.task.filename;
              await AddToGallery.addToGallery(
                originalFile: File(filePath),
                albumName: AppStrings.appName,
                deleteOriginalFile: true,
                keepFilename: true,
              );
              // print("Savd to gallery with Path: ${file.path}");
              // await SaverGallery.saveFile(
              //   filePath: filePath,
              //   fileName: fileName,
              //   skipIfExists: false,
              //   androidRelativePath: AppStrings.appName,
              // );
              // File file = File(filePath);
              // if (await file.exists()) {
              //   await file.delete();
              // }
              LoadingDialog.hide();
            case TaskStatus.canceled:
              LoadingDialog.hide();
            case TaskStatus.paused:
              LoadingDialog.hide();
            case TaskStatus.enqueued:
              LoadingDialog.show(Get.context!);
            default:
          }

        case TaskProgressUpdate():
        // downloadProgress.value = update.progress;
      }
    });

    FileDownloader().start();
    super.onInit();
  }

  Future<void> startDownload(
    BuildContext context,
    String url,
    bool isImage,
    String id,
  ) async {
    UnityAdsController unityAdsController = Get.find();
    if (!await _grantPermissions()) {
      return;
    }
    await unityAdsController.showInterstitialAd();

    Directory? dir = await getDownloadsDirectory();

    final task = DownloadTask(
      url: url,
      filename: Helpers.extractInstagramContentFilename(isImage, id),
      directory: dir?.path ?? '',
      baseDirectory: BaseDirectory.root,
      updates: Updates.statusAndProgress,
    );
    await FileDownloader().enqueue(task);
  }

  Future<void> startBatchDownload(
    BuildContext context,
    List<String> url,
    bool isImage,
    List<String> ids,
  ) async {
    UnityAdsController unityAdsController = Get.find();

    if (!await _grantPermissions()) {
      return;
    }
    await unityAdsController.showInterstitialAd();
    final tq = MemoryTaskQueue();
    tq.maxConcurrent = 1;
    Directory? dir = await getDownloadsDirectory();
    List<Task> tasks = [];
    FileDownloader().addTaskQueue(tq);
    for (var (i, id) in ids.indexed) {
      final task = DownloadTask(
        url: url[i],
        filename: Helpers.extractInstagramContentFilename(isImage, id),
        directory: dir?.path ?? '',
        baseDirectory: BaseDirectory.root,
        updates: Updates.statusAndProgress,
      );
      tasks.add(task);
      tq.add(task);
    }
  }

  Future<bool> _grantPermissions() async {
    bool result = true;
    final int? androidVersion =
        Platform.isAndroid
            ? (await DeviceInfoPlugin().androidInfo).version.sdkInt
            : null;
    // We need storage on:
    // - iOS to pick files from other apps
    // - Android < 13 for legacy access
    if (Platform.isIOS || (androidVersion != null && androidVersion <= 32)) {
      if (!await Permission.storage.request().isGranted) {
        result = false;
        throw ('Storage Permission Required');
      }
    }
    // We need photos on:
    // - iOS to pick files from this app
    // - Android >= 13
    if (Platform.isIOS || (androidVersion != null && androidVersion >= 33)) {
      if (!await Permission.photos.request().isGranted) {
        result = false;
        throw ('Photos Permission Required');
      }
    }
    return result;
  }
}
