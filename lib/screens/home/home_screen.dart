import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterapp/models/tweet.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';

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
      appBar: AppBar(),
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
                  if (!snapshots.hasData) {
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
                      return ListTile();
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
