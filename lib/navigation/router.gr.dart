// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../models/tweet.dart' as _i9;
import '../screens/authentication/login_screen.dart' as _i5;
import '../screens/authentication/registration_screen.dart' as _i4;
import '../screens/home/add_tweet_screen.dart' as _i7;
import '../screens/home/edit_tweet_screen.dart' as _i8;
import '../screens/home/home_screen.dart' as _i6;
import '../screens/splash_screen.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.SplashScreen();
        }),
    RegistrationScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.RegistrationScreen();
        }),
    LoginScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.LoginScreen();
        }),
    HomeScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.HomeScreen();
        }),
    AddTweetScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i7.AddTweetScreen();
        }),
    EditTweetScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<EditTweetScreenRouteArgs>();
          return _i8.EditTweetScreen(tweet: args.tweet, key: args.key);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i1.RouteConfig(RegistrationScreenRoute.name,
            path: '/registration-screen'),
        _i1.RouteConfig(LoginScreenRoute.name, path: '/login-screen'),
        _i1.RouteConfig(HomeScreenRoute.name, path: '/home-screen'),
        _i1.RouteConfig(AddTweetScreenRoute.name, path: '/add-tweet-screen'),
        _i1.RouteConfig(EditTweetScreenRoute.name, path: '/edit-tweet-screen')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo {
  const SplashScreenRoute() : super(name, path: '/');

  static const String name = 'SplashScreenRoute';
}

class RegistrationScreenRoute extends _i1.PageRouteInfo {
  const RegistrationScreenRoute() : super(name, path: '/registration-screen');

  static const String name = 'RegistrationScreenRoute';
}

class LoginScreenRoute extends _i1.PageRouteInfo {
  const LoginScreenRoute() : super(name, path: '/login-screen');

  static const String name = 'LoginScreenRoute';
}

class HomeScreenRoute extends _i1.PageRouteInfo {
  const HomeScreenRoute() : super(name, path: '/home-screen');

  static const String name = 'HomeScreenRoute';
}

class AddTweetScreenRoute extends _i1.PageRouteInfo {
  const AddTweetScreenRoute() : super(name, path: '/add-tweet-screen');

  static const String name = 'AddTweetScreenRoute';
}

class EditTweetScreenRoute extends _i1.PageRouteInfo<EditTweetScreenRouteArgs> {
  EditTweetScreenRoute({required _i9.Tweet tweet, _i2.Key? key})
      : super(name,
            path: '/edit-tweet-screen',
            args: EditTweetScreenRouteArgs(tweet: tweet, key: key));

  static const String name = 'EditTweetScreenRoute';
}

class EditTweetScreenRouteArgs {
  const EditTweetScreenRouteArgs({required this.tweet, this.key});

  final _i9.Tweet tweet;

  final _i2.Key? key;
}
