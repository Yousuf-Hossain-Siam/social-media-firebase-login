import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_login/custom_textfield.dart';
import 'package:social_media_login/profile.dart';
import 'package:social_media_login/social_media_login.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> signINWithGoogle() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Check if the user is null (cancelled the sign-in process)
      if (googleUser == null) {
      
        return; // Exit the function early if the user canceled
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      // You can now use userCredential to access user information
     
    } catch (e) {
      // Handle error
  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set to transparent to show gradient
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
                    // Handle Sign In button press
                  
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SocialMediaLogin(
                onGooglePressed: () async {
                  await signINWithGoogle();
                  // Optionally navigate to another screen after successful login
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                },
                onFacebookPressed: () {
                  // Handle Facebook login here
                  // print('Facebook login pressed');
                },
                onInstagramPressed: () {
                  // Handle Instagram login here
                  // print('Instagram login pressed');
                },
                onLinkedinPressed: () {
                  // Handle LinkedIn login here
                  // print('LinkedIn login pressed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
