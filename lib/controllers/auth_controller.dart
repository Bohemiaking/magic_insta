import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:magic_insta/controllers/fetch_posts_controller.dart';

class AuthController extends GetxController {
  var user = Rx<User?>(null);
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    user.bindStream(FirebaseAuth.instance.userChanges());
    ever(user, handleAuthChanged);
    super.onInit();
  }

  void handleAuthChanged(User? firebaseUser) {
    FetchPostsController fetchPostsController = Get.find();
    if (firebaseUser != null) {
      isLoggedIn.value = true;
      fetchPostsController.fetchUserHistory();
      debugPrint("User is logged in: ${firebaseUser.email}");
    } else {
      isLoggedIn.value = false;
      debugPrint("User is logged out");
    }
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      _signInWithGoogleWEB();
      return;
    }
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Google Sign-In error: $e");
    }
  }

  Future<UserCredential> _signInWithGoogleWEB() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope(
      'https://www.googleapis.com/auth/contacts.readonly',
    );
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
