import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/screens/splash_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
  ],
)
class $AppRouter {}
