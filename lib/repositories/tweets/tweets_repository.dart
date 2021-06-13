import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterapp/models/tweet.dart';

class TweetRepository {
  TweetRepository(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getTweetsStream() {
    final stream = _firebaseFirestore
        .collection('tweets')
        .orderBy('dateCreated', descending: true)
        .snapshots();
    return stream;
  }

  Future<void> addTweet(Tweet tweet) async {
    await _firebaseFirestore
        .collection('tweets')
        .add(tweet.toMap().remove('id'));
  }

  Future<void> editTweet(Tweet tweet) async {
    await _firebaseFirestore
        .collection('tweets')
        .doc(tweet.id)
        .update(tweet.toMap().remove('id'));
  }

  Future<void> deleteTweet(String id) async {
    await _firebaseFirestore.collection('tweets').doc(id).delete();
  }
}
