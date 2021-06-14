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

class EditTweetScreen extends StatefulWidget {
  const EditTweetScreen({required this.tweet, Key? key}) : super(key: key);
  final Tweet tweet;

  @override
  _EditTweetScreenState createState() => _EditTweetScreenState();
}

class _EditTweetScreenState extends State<EditTweetScreen> {
  late TweetBloc tweetBloc;
  final _tweetTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    tweetBloc = TweetBloc(RepositoryProvider.of<TweetRepository>(context));
    _tweetTextController.text = widget.tweet.text!;
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
          'Edit tweet',
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
            EasyLoading.show(status: 'Posting updated tweet...');
          } else if (listenState is TweetActionFailure) {
            EasyLoading.showError(listenState.errorMessage);
          } else if (listenState is TweetActionSuccess) {
            EasyLoading.showSuccess('Success! Updated tweet will appear soon!');
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
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final _tweet = widget.tweet.copyWith(
                        text: _tweetTextController.value.text,
                      );

                      tweetBloc.add(TweetEdit(_tweet));
                    }
                  },
                  child: Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
