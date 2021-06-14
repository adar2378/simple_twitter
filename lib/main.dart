import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:twitterapp/blocs/auth_bloc/authentication_bloc.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';

import 'blocs/bloc_observer.dart';
import 'navigation/router.gr.dart';
import 'repositories/authentication/authentication_repository.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    debugPrint(
      details.exceptionAsString(),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenticationRepository =
      AuthenticationRepository(FirebaseAuth.instance);
  final tweetRepository = TweetRepository(FirebaseFirestore.instance);

  runZonedGuarded(
    () => runApp(MyApp(
      authenticationRepository: authenticationRepository,
      tweetRepository: tweetRepository,
    )),
    (error, stackTrace) => debugPrint(error.toString()),
  );
}

class MyApp extends StatelessWidget {
  MyApp(
      {Key? key,
      required this.authenticationRepository,
      required this.tweetRepository})
      : super(key: key);
  final AuthenticationRepository authenticationRepository;
  final TweetRepository tweetRepository;
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: tweetRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationBloc(authenticationRepository),
        child: MaterialApp.router(
          title: 'Simple Twitter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
