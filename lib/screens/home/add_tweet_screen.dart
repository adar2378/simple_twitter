import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:twitterapp/blocs/tweet_bloc/tweet_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/models/tweet.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({Key? key}) : super(key: key);

  @override
  _AddTweetScreenState createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  late TweetBloc tweetBloc;
  final _tweetTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    tweetBloc = TweetBloc(RepositoryProvider.of<TweetRepository>(context));
    super.initState();
  }

  @override
  void dispose() {
    tweetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new tweet',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocListener(
        bloc: tweetBloc,
        listener: (context, listenState) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          if (listenState is TweetActionLoading) {
            EasyLoading.show(status: 'Posting new tweet...');
          } else if (listenState is TweetActionFailure) {
            EasyLoading.showError(listenState.errorMessage);
          } else if (listenState is TweetActionSuccess) {
            EasyLoading.showSuccess('Success! New tweet will appear soon!');
            context.router.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _tweetTextController,
                  maxLines: 4,
                  maxLength: 280,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator:
                      RequiredValidator(errorText: 'This field is required!'),
                  decoration: InputDecoration(
                    hintText: 'Type your tweet here...',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final user =
                        RepositoryProvider.of<AuthenticationRepository>(context)
                            .getCurrentUser();
                    if (user == null) {
                      EasyLoading.showError('User not found');
                    } else if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final _tweet = Tweet(
                        id: '0',
                        text: _tweetTextController.value.text,
                        userId: user.uid,
                        dateCreated: DateTime.now(),
                      );
                      print('twitting');
                      tweetBloc.add(TweetAdd(_tweet));
                    }
                  },
                  child: Text('Tweet'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
