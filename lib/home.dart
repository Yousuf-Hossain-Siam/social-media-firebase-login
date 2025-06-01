import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_login/custom_textfield.dart'; // CustomTextField
import 'package:social_media_login/services/linkedin_sign_in_service.dart'; // Import LinkedIn service
import 'package:social_media_login/profile.dart'; // Import Profile screen
import 'social_media_login.dart'; // Import the SocialMediaLogin widget
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for Google/Facebook login

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan,
              Colors.blue,
              Colors.indigo,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const CustomTextfield(
                icon: Icons.email_rounded,
                hintText: "Enter your email",
              ),
              const SizedBox(height: 20),
              const CustomTextfield(
                icon: Icons.lock,
                hintText: "Enter your password",
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 25,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Handle Sign In button press (email/password logic here)
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // SocialMediaLogin widget for LinkedIn, Google, Facebook
              SocialMediaLogin(
                onLinkedinPressed: () => _handleLinkedInLogin(context),
                onGooglePressed:() => _handleGoogleLogin(context),
                onFacebookPressed: () => _handleFacebookLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LinkedIn Login Function ---
  void _handleLinkedInLogin(BuildContext context) async {
    final LinkedInSignInService _linkedinSignInService = LinkedInSignInService();

    // Call LinkedIn sign-in service
    final result = await _linkedinSignInService.signInWithLinkedIn();
    if (result != null) {
      // If successful, navigate to Profile screen with LinkedIn data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            result: result, // Pass LinkedIn result
            loginMethod: 'linkedin', // Pass login method
          ),
        ),
      );
    } else {
      print("LinkedIn login failed");
    }
  }

  // --- Google Login Function ---
  void _handleGoogleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Profile screen with Google data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            result: {
              'userData': userCredential.user,
            },
            loginMethod: 'google',
          ),
        ),
      );
    } catch (e) {
      print("Google login failed: $e");
    }
  }

  // --- Facebook Login Function ---
  void _handleFacebookLogin(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to Profile screen with Facebook data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              result: {
                'userData': userCredential.user,
              },
              loginMethod: 'facebook',
            ),
          ),
        );
      } else {
        print("Facebook login failed");
      }
    } catch (e) {
      print("Facebook login error: $e");
    }
  }
}