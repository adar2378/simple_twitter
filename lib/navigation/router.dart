import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/screens/authentication/login_screen.dart';
import 'package:twitterapp/screens/authentication/registration_screen.dart';
import 'package:twitterapp/screens/home/add_tweet_screen.dart';
import 'package:twitterapp/screens/home/home_screen.dart';
import 'package:twitterapp/screens/splash_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: RegistrationScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: HomeScreen),
    AutoRoute(page: AddTweetScreen),
  ],
)
class $AppRouter {}
