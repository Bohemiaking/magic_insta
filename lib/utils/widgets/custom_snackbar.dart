import "package:flutter/material.dart";
import "package:get/get.dart";

class CustomSnackbar {
  static showSnackBar(BuildContext context, String? message,
      {bool isError = true}) {
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          isError ? Theme.of(Get.context!).colorScheme.error : null,
    ));
  }
}
