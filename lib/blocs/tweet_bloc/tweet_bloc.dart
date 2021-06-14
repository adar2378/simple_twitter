import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twitterapp/models/tweet.dart';
import 'package:twitterapp/repositories/tweets/tweets_repository.dart';

part 'tweet_event.dart';
part 'tweet_state.dart';

class TweetBloc extends Bloc<TweetEvent, TweetState> {
  TweetBloc(this._tweetRepository) : super(TweetInitial());

  final TweetRepository _tweetRepository;

  @override
  Stream<TweetState> mapEventToState(
    TweetEvent event,
  ) async* {
    if (event is TweetAdd) {
      yield* _addTweet(event);
    } else if (event is TweetEdit) {
      yield* _editTweet(event);
    } else if (event is TweetDelete) {
      yield* _deleteTweet(event);
    }
  }

  Stream<TweetState> _addTweet(TweetAdd event) async* {
    yield (TweetActionLoading());
    try {
      await _tweetRepository.addTweet(event.tweet);
      yield (TweetActionSuccess());
    } catch (e, st) {
      print(e);
      print(st);
      String? errorMessage;
      if (e is TweetException) {
        errorMessage = e.message;
      }
      yield (TweetActionFailure(errorMessage ?? 'Failed to add a new tweet!'));
    }
  }

  Stream<TweetState> _editTweet(TweetEdit event) async* {
    yield (TweetActionLoading());
    try {
      await _tweetRepository.editTweet(event.tweet);
      yield (TweetActionSuccess());
    } catch (e) {
      String? errorMessage;
      if (e is TweetException) {
        errorMessage = e.message;
      }
      yield (TweetActionFailure(
          errorMessage ?? 'Failed to edit the tweet ${event.tweet.id}!'));
    }
  }

  Stream<TweetState> _deleteTweet(TweetDelete event) async* {
    yield (TweetActionLoading());
    try {
      await _tweetRepository.deleteTweet(event.id);
      yield (TweetActionSuccess());
    } catch (e) {
      String? errorMessage;
      if (e is TweetException) {
        errorMessage = e.message;
      }
      yield (TweetActionFailure(
          errorMessage ?? 'Failed to delete the tweet ${event.id}!'));
    }
  }
}
