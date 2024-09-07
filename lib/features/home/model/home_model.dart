import 'package:cloud_firestore/cloud_firestore.dart';

class HomeChatModel {
  final String name;
  final String lastMessage;
  final String profilePic;
  final DateTime timeSent;
  final String userId;
  final int numberOfNotSeenMessages;

  HomeChatModel(
      {required this.name,
      required this.lastMessage,
      required this.profilePic,
      required this.timeSent,
      required this.userId,
      required this.numberOfNotSeenMessages});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'profilePic': profilePic,
      'timeSent': timeSent,
      'userId': userId,
      'numberOfNotSeenMessages': numberOfNotSeenMessages
    };
  }

  factory HomeChatModel.fromMap(Map<String, dynamic> map) {
    return HomeChatModel(
        name: map['name'] as String,
        lastMessage: map['lastMessage'] as String,
        profilePic: map['profilePic'] as String,
        timeSent: (map['timeSent'] as Timestamp).toDate(),
        numberOfNotSeenMessages: map['numberOfNotSeenMessages'],
        userId: map['userId'] as String);
  }

  HomeChatModel copyWith({
    String? name,
    String? lastMessage,
    String? profilePic,
    DateTime? timeSent,
    String? userId,
    int? numberOfNotSeenMessages,
  }) {
    return HomeChatModel(
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      profilePic: profilePic ?? this.profilePic,
      timeSent: timeSent ?? this.timeSent,
      userId: userId ?? this.userId,
      numberOfNotSeenMessages:
          numberOfNotSeenMessages ?? this.numberOfNotSeenMessages,
    );
  }
}
