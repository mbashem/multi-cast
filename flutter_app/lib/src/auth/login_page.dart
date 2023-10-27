import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/log_print.dart';
import './auth_repository.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleSignIn() async {
    print("handle sign in called");
    try {
      print("Calling");
      final account = await signInWithGoogle();
      var tokenResult = await FirebaseAuth.instance.currentUser?.getIdToken();
      debugPrint("Token:$tokenResult-END");
      logPrint("tokenResult: $tokenResult-END");
      // final idToken = await tokenResult.getIdToken();
      // print(idToken);

      // print(account.)
      print(account.user);
      print(account.credential);
      // print(account.credential?.accessToken);
      // Use account for user information, or proceed with Step 5.
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
