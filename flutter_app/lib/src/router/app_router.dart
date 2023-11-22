import 'package:auto_route/auto_route.dart';
import 'package:flutter_app/src/auth/auth_provider.dart';
import 'package:flutter_app/src/auth/login_page.dart';
import 'package:flutter_app/src/home/home_page.dart';
import 'package:flutter_app/src/router/app_router.gr.dart';
import 'package:flutter_app/src/router/auth_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  final AuthProvider authProvider;
  AppRouter({required this.authProvider});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            path: HomePage.routeName,
            page: HomeRoute.page,
            guards: [AuthGuard(authProvider: authProvider)]),
        AutoRoute(
            path: "/meeting/:meetingId",
            page: MeetingRoute.page,
            keepHistory: false,
            guards: [AuthGuard(authProvider: authProvider)]),
        AutoRoute(
            path: LoginPage.routeName,
            page: LoginRoute.page,
            keepHistory: false),
      ];
}
