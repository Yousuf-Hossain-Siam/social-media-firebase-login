import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  final Map<String, dynamic>? result;  // Accept login result (LinkedIn, Google, or Facebook data)
  final String? loginMethod;  // Accept the login method (Google, Facebook, LinkedIn)

  const Profile({super.key, this.result, this.loginMethod});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Determine which data to show based on login method
    String profilePictureUrl = '';
    String displayName = '';
    String email = '';

    if (loginMethod == 'linkedin' && result != null && result!['userData'] is Map) {
      // --- CHANGES START HERE for LinkedIn OIDC /v2/userinfo data ---
      final linkedinUserData = result!['userData'];
      profilePictureUrl = linkedinUserData['picture'] ?? 'https://default-image-url.com';
      displayName = linkedinUserData['name'] ?? 'LinkedIn User'; // Full name
      email = linkedinUserData['email'] ?? 'No email available';
      // --- CHANGES END HERE ---
    } else if (loginMethod == 'google' && user != null) {
      // Google data
      profilePictureUrl = user.photoURL ?? 'https://default-image-url.com';
      displayName = user.displayName ?? 'Google User';
      email = user.email ?? 'No email available';
    } else if (loginMethod == 'facebook' && user != null) {
      // Facebook data
      profilePictureUrl = user.photoURL ?? 'https://default-image-url.com';
      displayName = user.displayName ?? 'Facebook User';
      email = user.email ?? 'No email available';
    } else {
      // Fallback: Firebase user data (if user is logged in via email/password or other methods)
      profilePictureUrl = user?.photoURL ?? 'https://default-image-url.com';
      displayName = user?.displayName ?? 'Unknown User';
      email = user?.email ?? 'No email available';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display profile image based on login method
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            const SizedBox(height: 20),
            Text(
              displayName,
              style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 40),
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
                  // Handle Firebase logout
                  await FirebaseAuth.instance.signOut();
                  // Ensure you navigate back to the appropriate login/home screen.
                  // If you have a named route for your Home screen (e.g., '/home'),
                  // you could use Navigator.pushReplacementNamed(context, '/home');
                  // Otherwise, pop until the first route or push a new route.
                  Navigator.pop(context); // Pops the current Profile screen
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}