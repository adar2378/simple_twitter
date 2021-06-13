part of 'tweet_bloc.dart';

@immutable
abstract class TweetEvent {}

class TweetAdd extends TweetEvent {
  TweetAdd(this.tweet);
  final Tweet tweet;
}

class TweetEdit extends TweetEvent {
  TweetEdit(this.tweet);
  final Tweet tweet;
}

class TweetDelete extends TweetEvent {
  TweetDelete(this.id);
  final String id;
}
