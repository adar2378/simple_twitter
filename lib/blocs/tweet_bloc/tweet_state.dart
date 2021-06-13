part of 'tweet_bloc.dart';

@immutable
abstract class TweetState {}

class TweetInitial extends TweetState {}

class TweetActionLoading extends TweetState {}

class TweetActionSuccess extends TweetState {}

class TweetActionFailure extends TweetState {
  TweetActionFailure(this.errorMessage);
  final String errorMessage;
}
