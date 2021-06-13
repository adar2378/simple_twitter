import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterapp/models/tweet.dart';

class TweetException implements Exception {
  final String? message;

  TweetException(this.message);
}

class TweetRepository {
  TweetRepository(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getTweetsStream() {
    try {
      final stream = _firebaseFirestore
          .collection('tweets')
          .orderBy('dateCreated', descending: true)
          .snapshots();
      return stream;
    } catch (e, st) {
      throw (TweetException('Error: $e, Stacktrace: $st'));
    }
  }

  Future<void> addTweet(Tweet tweet) async {
    try {
      await _firebaseFirestore
          .collection('tweets')
          .add(tweet.toMap().remove('id'));
    } catch (e, st) {
      throw (TweetException('Error: $e, Stacktrace: $st'));
    }
  }

  Future<void> editTweet(Tweet tweet) async {
    try {
      await _firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update(tweet.toMap().remove('id'));
    } catch (e, st) {
      throw (TweetException('Error: $e, Stacktrace: $st'));
    }
  }

  Future<void> deleteTweet(String id) async {
    try {
      await _firebaseFirestore.collection('tweets').doc(id).delete();
    } catch (e, st) {
      throw (TweetException('Error: $e, Stacktrace: $st'));
    }
  }
}
