import 'package:cloud_firestore/cloud_firestore.dart';

class HomeChatModel {
  final String name;
  final String lastMessage;
  final String profilePic;
  final DateTime timeSent;
  final String userId;

  HomeChatModel(
      {required this.name,
      required this.lastMessage,
      required this.profilePic,
      required this.timeSent,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'profilePic': profilePic,
      'timeSent': timeSent,
      'userId': userId
    };
  }

  factory HomeChatModel.fromMap(Map<String, dynamic> map) {
    return HomeChatModel(
        name: map['name'] as String,
        lastMessage: map['lastMessage'] as String,
        profilePic: map['profilePic'] as String,
        timeSent: (map['timeSent'] as Timestamp).toDate(),
        userId: map['userId'] as String);
  }
}
