class Helpers {
  static String extractInstagramContentFilename(bool isImage, String id) {
    return id + (isImage ? '.jpg' : '.mp4');
  }

  static String? extractInstagramPostShortcode(String url) {
    final RegExp regExp = RegExp(
      r'instagram\.com\/(?:p|reel)\/([a-zA-Z0-9_-]+)',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }
}
