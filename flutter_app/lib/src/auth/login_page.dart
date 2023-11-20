import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/router/app_router.gr.dart';
import 'auth_service.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  Function(bool loggedIn)? onLoginCallback;
  LoginPage({super.key, this.onLoginCallback});

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
      await AuthService.saveUserName(user.additionalUserInfo?.profile?["name"]);
      var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      var jwtToken = await AuthService.getJWTFromBackend(idToken);

      await AuthService.saveJWTToken(jwtToken);
      MyApp.of(context).authProvider.login();
      // context.authProvider.login();
      if (widget.onLoginCallback != null) {
        widget.onLoginCallback!(true);
      } else {
        context.router.replaceNamed(HomeRoute.name);
      }

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
          child: SizedBox(
            width: 220,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    // decoration: BoxDecoration(color: Colors.blue),
                    child: Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        fit: BoxFit.cover)),
                const SizedBox(
                  width: 5.0,
                ),
                const Text('Sign-in with Google')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
