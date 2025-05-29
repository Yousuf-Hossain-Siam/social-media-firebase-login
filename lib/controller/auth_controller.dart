// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthController extends GetxController {
//   var user = Rx<User?>(null); // Reactive user state

//   @override
//   void onInit() {
//     super.onInit();
//     // Check if a user is already signed in when the app starts
//     user.value = FirebaseAuth.instance.currentUser;
//   }

//   // Sign in with Google
//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn();

//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser == null) {
//         // print("Google Sign-In canceled");
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       user.value = userCredential.user; // Update the user state
//     } catch (e) {
//       print("Error signing in with Google: $e");
//     }
//   }

//   // Sign out function
//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//     await GoogleSignIn().signOut();
//     user.value = null; // Reset user state
//     print("User signed out");
//   }
// }
