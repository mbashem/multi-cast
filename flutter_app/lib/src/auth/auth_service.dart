import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            // scopes: ['email'],
            )
        .signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<String?> getJWTFromBackend(String? idToken) async {
    // await signInWithGoogle();
    if (idToken == null) return null;
    final Map<String, String> data = {
      'idToken': idToken,
    };

    var url = "$apiURL/public/auth/google-signin";
    final String body = jsonEncode(data);
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["token"];
    } else {
      logger.e('Request failed with status: ${response.statusCode}');
      logger.e('Error message: ${response.body}');
      return null;
    }
  }

  static Future<String?> getJWTTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  static Future<String?> getJWTToken() async {
    var savedJWT = await getJWTTokenFromLocalStorage();
    if (savedJWT != null) return savedJWT;
    var jwtToken = await getJWTToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (jwtToken != null) {
      await prefs.setString('jwtToken', jwtToken);
    }
    return jwtToken;
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await FirebaseAuth.instance.signOut();
  }
}
