import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map<String, dynamic>?> signInWithFacebook() async {
  try {
    // First, check if the user is already logged in with Facebook
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      // If the user is already logged in, get the user data from Facebook without showing the login screen
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200)",
      );

      final String fbProfileImageUrl = userData['picture']['data']['url'];

      // Use the existing access token to sign in to Firebase
      final credential = FacebookAuthProvider.credential(accessToken.tokenString);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return {
        'userCredential': userCredential,
        'profileImageUrl': fbProfileImageUrl,
      };
    } else {
      // If not logged in, trigger the login flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        final String fbProfileImageUrl = userData['picture']['data']['url'];

        final credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        return {
          'userCredential': userCredential,
          'profileImageUrl': fbProfileImageUrl,
        };
      } else {
        print('Facebook login failed: ${loginResult.status}');
        return null;
      }
    }
  } catch (e) {
    print('Facebook sign-in error: $e');
    return null;
  }
}
