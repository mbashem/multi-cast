// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:flutter_app/src/auth/login_page.dart' as _i2;
import 'package:flutter_app/src/home/home_page.dart' as _i1;
import 'package:flutter_app/src/meeting/meeting_page.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.LoginPage(
          key: args.key,
          onLoginCallback: args.onLoginCallback,
        ),
      );
    },
    MeetingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MeetingRouteArgs>(
          orElse: () =>
              MeetingRouteArgs(meetingId: pathParams.getString('meetingId')));
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.MeetingPage(
          key: args.key,
          meetingId: args.meetingId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i5.Key? key,
    dynamic Function(bool)? onLoginCallback,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLoginCallback: onLoginCallback,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i4.PageInfo<LoginRouteArgs> page =
      _i4.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onLoginCallback,
  });

  final _i5.Key? key;

  final dynamic Function(bool)? onLoginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginCallback: $onLoginCallback}';
  }
}

/// generated route for
/// [_i3.MeetingPage]
class MeetingRoute extends _i4.PageRouteInfo<MeetingRouteArgs> {
  MeetingRoute({
    _i5.Key? key,
    required String meetingId,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          MeetingRoute.name,
          args: MeetingRouteArgs(
            key: key,
            meetingId: meetingId,
          ),
          rawPathParams: {'meetingId': meetingId},
          initialChildren: children,
        );

  static const String name = 'MeetingRoute';

  static const _i4.PageInfo<MeetingRouteArgs> page =
      _i4.PageInfo<MeetingRouteArgs>(name);
}

class MeetingRouteArgs {
  const MeetingRouteArgs({
    this.key,
    required this.meetingId,
  });

  final _i5.Key? key;

  final String meetingId;

  @override
  String toString() {
    return 'MeetingRouteArgs{key: $key, meetingId: $meetingId}';
  }
}
