import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterapp/navigation/router.gr.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final authRepo = context.read<AuthenticationRepository>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (authRepo.isLoggedIn()) {
        context.router.replace(HomeScreenRoute());
      } else {
        context.router.replace(LoginScreenRoute());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Simple Twitter')),
    );
  }
}
