import 'package:auto_route/auto_route.dart';
import 'package:flutter_app/src/auth/auth_provider.dart';
import 'package:flutter_app/src/router/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthProvider authProvider;
  AuthGuard({required this.authProvider});
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (authProvider.isLoggedIn) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(LoginRoute(onLoginCallback: (success) {
        // if success == true the navigation will be resumed
        // else it will be aborted
        resolver.next(success);
      }));
    }
  }
}
