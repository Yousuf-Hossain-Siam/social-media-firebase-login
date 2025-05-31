import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_login/config/config.dart';


class LinkedInSignInService {
  // Use the credentials from LinkedInConfig class
  static const String clientId = LinkedInConfig.clientId;
  static const String clientSecret = LinkedInConfig.clientSecret;
  static const String redirectUri = LinkedInConfig.redirectUri;

  // Function to start the LinkedIn sign-in process
  Future<Map<String, dynamic>?> signInWithLinkedIn() async {
    try {
        final String scope = 'openid profile email'; 

      // Step 1: Generate the LinkedIn authentication URL
      final String authUrl =
          'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope';
       print('LinkedIn Auth URL: $authUrl');
      // Step 2: Trigger OAuth login flow with the generated URL
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: redirectUri.split("://")[0],  // Custom URI scheme
      );
       print('DEBUG: FlutterWebAuth2 result: $result');
      // Step 3: Extract the authorization code from the redirect URL
      final Uri resultUri = Uri.parse(result);
      final String? code = resultUri.queryParameters['code'];

      if (code != null) {
        // Step 4: Exchange the authorization code for an access token
        final String accessToken = await _getAccessToken(code, clientId, clientSecret, redirectUri);

        // Step 5: Use the access token to fetch user data
        final Map<String, dynamic> userData = await _getLinkedInUserData(accessToken);

        // Step 6: Use the access token to sign in to Firebase
        final credential = OAuthCredential(
          providerId: 'linkedin.com',
          signInMethod: 'linkedin.com',
          accessToken: accessToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        return {
          'userCredential': userCredential,
          'userData': userData,
        };
      } else {
        print('Failed to retrieve authorization code');
        return null;
      }
    } catch (e) {
      print('LinkedIn sign-in error: $e');
      return null;
    }
  }

  // Function to exchange the authorization code for an access token
  Future<String> _getAccessToken(String code, String clientId, String clientSecret, String redirectUri) async {
    final response = await http.post(
      Uri.parse('https://www.linkedin.com/oauth/v2/accessToken'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,  // Match the redirect URI
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  // Function to fetch user data from LinkedIn
  Future<Map<String, dynamic>> _getLinkedInUserData(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.linkedin.com/v2/userinfo'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load LinkedIn user data from /userinfo: ${response.statusCode} ${response.body}');
    }
  }
}
