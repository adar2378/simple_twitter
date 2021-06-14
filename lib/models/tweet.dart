import 'dart:convert';

class Tweet {
  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      id: map['id'],
      text: map['text'],
      dateCreated: DateTime.parse(map['dateCreated']),
      userId: map['userId'],
    );
  }
  Tweet({
    this.id,
    this.text,
    this.dateCreated,
    this.userId,
  });
  factory Tweet.fromJson(String source) => Tweet.fromMap(json.decode(source));

  final String? id;
  final String? text;
  final DateTime? dateCreated;
  final String? userId;

  Tweet copyWith({
    String? id,
    String? text,
    DateTime? dateCreated,
    String? userId,
  }) {
    return Tweet(
      id: id ?? this.id,
      text: text ?? this.text,
      dateCreated: dateCreated ?? this.dateCreated,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'dateCreated': dateCreated?.toIso8601String(),
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Tweet(id: $id, text: $text, dateCreated: $dateCreated, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tweet &&
        other.id == id &&
        other.text == text &&
        other.dateCreated == dateCreated &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ dateCreated.hashCode ^ userId.hashCode;
  }
}
