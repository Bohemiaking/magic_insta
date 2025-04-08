import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_insta/controllers/auth_controller.dart';
import 'package:magic_insta/models/instagram_post_model.dart';
import 'package:magic_insta/services/api_services.dart';
import 'package:magic_insta/utils/constants/firestore_strings.dart';
import 'package:magic_insta/utils/constants/urls/app_urls.dart';
import 'package:magic_insta/utils/helpers/helpers.dart';

class FetchPostsController extends GetxController {
  final ApiService _api = ApiService();
  RxBool isLoading = false.obs;
  RxList<InstagramPostModel> history = <InstagramPostModel>[].obs;
  RxBool isLoadingHistory = false.obs;

  Future<InstagramPostModel?> fetchInstagramPosts(
    BuildContext context,
    String url, {
    String? videoUrl,
  }) async {
    AuthController authController = Get.find();
    isLoading.value = true;
    InstagramPostModel? post;
    String shortCode = Helpers.extractInstagramPostShortcode(url) ?? '';
    bool isPostAvailableInHistory = false;
    bool isVideoUrlSignatureExpired = await isInstagramVideoUrlSignatureExpired(
      context,
      videoUrl,
    );

    post = await getInstagramPostFromHistory(
      authController.user.value!.uid,
      shortCode,
    );

    if (post?.id != null) {
      debugPrint('Available in history');
      isPostAvailableInHistory = true;
    }

    if (isPostAvailableInHistory && !isVideoUrlSignatureExpired) {
      isLoading.value = false;
      debugPrint('Available in history and signature not expired');
    } else if (context.mounted) {
      debugPrint(
        'Not Available in history or signature Might expired, getting post from API',
      );
      var payload = {
        "directUrls": [url],
        "resultsType": "posts",
      };

      try {
        await _api.post(context, AppUrls.instagram, payload).then((
          response,
        ) async {
          if (response.statusCode == 201) {
            post = InstagramPostModel.fromJson(response.data[0]);
            if (post?.id != null) {
              await saveHistory(post!);
            }
          }
        });
      } finally {
        isLoading.value = false;
      }
    }
    return post?.id != null ? post : null;
  }

  Future<void> fetchUserHistory() async {
    AuthController authController = Get.find();
    if (authController.isLoggedIn.isFalse) {
      return;
    }
    isLoadingHistory.value = true;
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection(FirestoreStrings.usersCollection)
              .doc(authController.user.value?.uid)
              .collection(FirestoreStrings.historyCollection)
              .orderBy(FirestoreStrings.createdAt, descending: true)
              .get();
      history.clear();
      history.addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return InstagramPostModel.fromJson(data);
        }).toList(),
      );
    } catch (e) {
      debugPrint("Error fetching history: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<bool> isInstagramVideoUrlSignatureExpired(
    BuildContext context,
    String? videoUrl,
  ) async {
    bool result = false;
    if (videoUrl == null) {
      return result;
    }
    try {
      await _api.get(context, videoUrl).then((response) {
        result = response.data == 'URL signature expired';
      });
    } catch (e) {
      result = true;
    }
    return result;
  }

  Future<InstagramPostModel?> getInstagramPostFromHistory(
    String userId,
    String shortCode,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(FirestoreStrings.usersCollection)
            .doc(userId)
            .collection(FirestoreStrings.historyCollection)
            .where('shortCode', isEqualTo: shortCode)
            .limit(1)
            .get();
    return snapshot.docs.isEmpty
        ? null
        : snapshot.docs
            .map((doc) {
              final data = doc.data();
              return InstagramPostModel.fromJson(data);
            })
            .toList()
            .first;
  }

  Future<void> saveHistory(InstagramPostModel post) async {
    AuthController authController = Get.find();
    try {
      final historyRef = FirebaseFirestore.instance
          .collection(FirestoreStrings.usersCollection)
          .doc(authController.user.value?.uid)
          .collection(FirestoreStrings.historyCollection);

      final querySnapshot =
          await historyRef
              .where('shortCode', isEqualTo: post.shortCode)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Remove 'createdAt' before updating
        final updatedData = Map<String, dynamic>.from(post.toJson());
        updatedData.remove('createdAt');

        await querySnapshot.docs.first.reference.update(updatedData);
      } else {
        // Add new post with all data (including createdAt)
        await historyRef.add(post.toJson());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    } finally {
      fetchUserHistory();
    }
  }
}
