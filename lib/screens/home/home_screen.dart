import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterapp/helpers/datetime_formatter.dart';
import 'package:twitterapp/models/tweet.dart';
import 'package:twitterapp/navigation/router.gr.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/screens/home/add_tweet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _tweetStream;

  @override
  void initState() {
    final currentUser = RepositoryProvider.of<AuthenticationRepository>(context)
        .getCurrentUser();
    if (currentUser != null) {
      _tweetStream = RepositoryProvider.of<TweetRepository>(context)
          .getTweetsStream(currentUser.uid);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      (x) => Tweet.fromMap(
                        (x.data() as Map<String, dynamic>),
                      ),
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
                          itemBuilder: (context) {
                            final list = <PopupMenuEntry>[
                              PopupMenuItem(child: Text('Edit')),
                              PopupMenuItem(child: Text('Delete')),
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
    );
  }
}
