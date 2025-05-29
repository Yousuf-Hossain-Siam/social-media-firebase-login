import 'package:flutter/material.dart';

class SocialMediaLogin extends StatelessWidget {
  final VoidCallback onFacebookPressed;
  final VoidCallback onInstagramPressed;
  final VoidCallback onLinkedinPressed;
  final VoidCallback onGooglePressed; // Added callback for Google

  const SocialMediaLogin({
    super.key,
    required this.onFacebookPressed,
    required this.onInstagramPressed,
    required this.onLinkedinPressed,
    required this.onGooglePressed, // Added Google callback parameter
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialMediaButton(
          context: context,
          imagePath: 'assets/images/facebook.png',
          onPressed: onFacebookPressed,
        ),
        SizedBox(width: 16),
        _socialMediaButton(
          context: context,
          imagePath: 'assets/images/instagram.png',
          onPressed: onInstagramPressed,
        ),
        SizedBox(width: 16),
        _socialMediaButton(
          context: context,
          imagePath: 'assets/images/linkedin.png',
          onPressed: onLinkedinPressed,
        ),
        SizedBox(width: 16),
        _socialMediaButton(
          context: context,
          imagePath: 'assets/images/google.png', // Make sure the path is correct
          onPressed: onGooglePressed, // Using Google callback
        ),
      ],
    );
  }

  Widget _socialMediaButton({
    required BuildContext context,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height / 20,
        width: MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}