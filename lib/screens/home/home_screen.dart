import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:twitterapp/blocs/tweet_bloc/tweet_bloc.dart';
import 'package:twitterapp/helpers/datetime_formatter.dart';
import 'package:twitterapp/models/tweet.dart';
import 'package:twitterapp/navigation/router.gr.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';
import 'package:auto_route/auto_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _tweetStream;

  late TweetBloc tweetBloc;

  @override
  void initState() {
    final tweetRepo = RepositoryProvider.of<TweetRepository>(context);
    tweetBloc = TweetBloc(tweetRepo);
    final currentUser = RepositoryProvider.of<AuthenticationRepository>(context)
        .getCurrentUser();
    if (currentUser != null) {
      _tweetStream = tweetRepo.getTweetsStream(currentUser.uid);
    }

    super.initState();
  }

  @override
  void dispose() {
    tweetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TweetBloc, TweetState>(
      bloc: tweetBloc,
      listener: (context, listenState) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (listenState is TweetActionLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (listenState is TweetActionSuccess) {
          EasyLoading.showSuccess('Tweet deteled sucessfully!');
        } else if (listenState is TweetActionFailure) {
          EasyLoading.showError('Failed to perfrom the action!');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tweet feed',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.power_settings_new),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _tweetStream == null
              ? null
              : () {
                  context.router.push(AddTweetScreenRoute());
                },
        ),
        body: _tweetStream == null
            ? Center(
                child: Text('No user found!'),
              )
            : Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _tweetStream,
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshots.data == null) {
                      return const Text('Your feed is empty');
                    }
                    final items = snapshots.data!.docs;

                    final tweets = List<Tweet>.from(
                      items.map(
                        (x) {
                          var map = (x.data() as Map<String, dynamic>);
                          map['id'] = x.id;
                          return Tweet.fromMap(map);
                        },
                      ),
                    );

                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final currentTweet = tweets[index];
                        return ListTile(
                          contentPadding: EdgeInsets.only(
                            left: 16,
                          ),
                          title: Text(
                            currentTweet.dateCreated == null
                                ? ''
                                : DateTimeFormatter.formatDateTime(
                                    currentTweet.dateCreated!,
                                  ),
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            currentTweet.text ?? '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (selectedValue) {
                              if (selectedValue == 'edit') {
                                context.router.push(
                                    EditTweetScreenRoute(tweet: currentTweet));
                              } else if (selectedValue == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete?'),
                                    content: Text(
                                        'Tweet will be deleted permanently'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            tweetBloc.add(
                                                TweetDelete(currentTweet.id!));
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes')),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) {
                              final list = <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
                                PopupMenuItem<String>(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ];
                              return list;
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: tweets.length,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
