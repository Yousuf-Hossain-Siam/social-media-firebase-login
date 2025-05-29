import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:social_media_login/home.dart'; // Import your home screen for navigation

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Logout function
  Future<void> signOut(BuildContext context) async {
    try {
      // Sign out of Firebase
      await FirebaseAuth.instance.signOut();
      // print("User signed out from Firebase");

      // Sign out from Google
      await GoogleSignIn().signOut();
      // print("User signed out from Google");

      // Navigate to Home page after logging out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()), // Replace Profile screen with Home screen
      );
    } catch (e) {
      // print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the user's profile picture (Google profile image)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.photoURL ?? 'https://www.example.com/default_image.jpg'), // Default image if null
          ),
          const SizedBox(height: 20),
          // Display the user's name
          Text(
            user?.displayName ?? 'Unknown User', // Fallback if name is null
            style: const TextStyle(
              fontSize: 24,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Display a sign-up success message
          Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.limeAccent,
                  Colors.lightGreenAccent,
                  Colors.greenAccent,
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Successfully Signed Up',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Logout button
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                await signOut(context); // Sign out the user
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
