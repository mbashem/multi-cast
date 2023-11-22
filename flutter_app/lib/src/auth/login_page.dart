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
      widget.onLoginCallback!(true);

      debugPrint("Token:$jwtToken");
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  initState() {
    super.initState();
    if (widget.onLoginCallback == null) {
      AutoRouter.of(context).replace(HomeRoute());
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
          child: const SizedBox(
            width: 220,
            height: 80,
            child: Center(
              child: Text('Sign-in with Google'),
            ),
          ),
        ),
      ),
    );
  }
}
