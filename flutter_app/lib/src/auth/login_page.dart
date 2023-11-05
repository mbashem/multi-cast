import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleSignIn() async {
    debugPrint("handle sign in called");
    try {
      debugPrint("Calling");
      var user = await AuthService.signInWithGoogle();
      debugPrint("User:$user");
      var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      var jwtToken = await AuthService.getJWTFromBackend(idToken);

      debugPrint("Token:$jwtToken");
    } catch (error) {
      debugPrint('Google Sign-In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register/Login'),
      ),
      body: Center(
        child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
          ),
          onPressed: _handleSignIn,
          child: Container(
            width: 220,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    // decoration: BoxDecoration(color: Colors.blue),
                    child: Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        fit: BoxFit.cover)),
                SizedBox(
                  width: 5.0,
                ),
                Text('Sign-in with Google')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
