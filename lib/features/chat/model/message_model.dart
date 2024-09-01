import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String messageId;
  final DateTime timeSent;

  MessageModel(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.messageId,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageId': messageId,
      'timeSent': timeSent,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      messageId: map['messageId'] as String,
      timeSent: (map['timeSent'] as Timestamp).toDate(),
    );
  }
}
