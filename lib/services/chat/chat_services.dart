import 'dart:developer';

import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/features/chat/model/message_model.dart';
import 'package:chat_app_flutter/features/home/model/home_model.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final ChatServices chatServices = ChatServices._();

  ChatServices._();

  Future<void> sendTextMessage(
    UserModel sender,
    String receiverId,
    String message,
  ) async {
    try {
      final stopwatch = Stopwatch()..start();
      print("started");
      //create unique message id
      String messageId = const Uuid().v1();
      var time = DateTime.now();
      //getting receiver data with receiver id
      final receiverModel = FireStoreService.receiverUserData;

      //creating userModel of receiver from received receiver data

      stopwatch.stop();
      print('sendTextMessage duration: ${stopwatch.elapsedMilliseconds}ms');
      //method to save messages to database
      _saveMessageToSubCollection(
          senderId: sender.uid,
          receiverId: receiverId,
          message: message,
          messageId: messageId,
          timeSent: time);
      // method to save last send message to database

      print("uploaded to db");
      _saveLastSendMessage(
          receiver: receiverModel!,
          sender: sender,
          lastMessage: message,
          timeSent: time);
    } catch (e) {
      log(e.toString() + "this error cause here");
    }
  }

  Future<void> _saveMessageToSubCollection(
      {required String senderId,
      required String receiverId,
      required String message,
      required String messageId,
      required DateTime timeSent}) async {
    // creating message Model from received parameters
    try {
      // Create a message Model from received parameters
      MessageModel messageModel = MessageModel(
          senderId: senderId,
          receiverId: receiverId,
          message: message,
          messageId: messageId,
          timeSent: timeSent);

      // Create a Firestore batch
      WriteBatch batch = fireStore.batch();

      // Define document references
      DocumentReference senderMessageRef = fireStore
          .collection("users")
          .doc(senderId)
          .collection("chats")
          .doc(receiverId)
          .collection("messages")
          .doc(messageId);

      DocumentReference receiverMessageRef = fireStore
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(senderId)
          .collection("messages")
          .doc(messageId);

      // Set the data in the batch
      batch.set(senderMessageRef, messageModel.toMap());
      batch.set(receiverMessageRef, messageModel.toMap());

      // Commit the batch
      await batch.commit();
    } catch (e) {
      log(e.toString() + " this error caused here");
    }
  }

  Future<void> _saveLastSendMessage(
      {required UserModel sender,
      required UserModel receiver,
      required String lastMessage,
      required DateTime timeSent}) async {
    // created a homeChatModel of sender with received parameter (sender will see receiver data on home screen)
    HomeChatModel senderData = HomeChatModel(
        name: receiver.name,
        lastMessage: lastMessage,
        profilePic: receiver.profilePic,
        timeSent: timeSent,
        userId: receiver.uid);
    // created a homeChatModel of receiver with received parameter(receiver will see sender data on home screen)

    HomeChatModel receiverData = HomeChatModel(
        name: sender.name,
        lastMessage: lastMessage,
        profilePic: sender.profilePic,
        timeSent: timeSent,
        userId: sender.uid);

    //storing last message and details inside senderId(current user)-> chats(collection)->receiverId(doc)->stored data
    await fireStore
        .collection("users")
        .doc(sender.uid)
        .collection("chats")
        .doc(receiver.uid)
        .set(senderData.toMap());
    //reverse storing last message and details inside receiverId(opposite user)-> chats(collection)->senderId(doc)->stored data
    await fireStore
        .collection("users")
        .doc(receiver.uid)
        .collection("chats")
        .doc(sender.uid)
        .set(receiverData.toMap());
  }

  Stream<List<HomeChatModel>> getHomeChats() {
    return fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((collection) async {
      final stopwatch = Stopwatch()..start(); // Start the stopwatch

      try {
        // Extract userIds from chat documents
        List<String> userIds = collection.docs
            .map((doc) => HomeChatModel.fromMap(doc.data()))
            .map((homeChat) => homeChat.userId)
            .toList();

        // Fetch user data in a single batch request
        final userSnapshots = await fireStore
            .collection("users")
            .where(FieldPath.documentId, whereIn: userIds)
            .get();

        // Map user data to a dictionary for quick lookup
        Map<String, UserModel> users = {
          for (var doc in userSnapshots.docs)
            doc.id: UserModel.fromMap(doc.data())
        };

        // Map chat data to HomeChatModel using the fetched user data
        List<HomeChatModel> homeChats = collection.docs
            .map((doc) {
              HomeChatModel homeUser = HomeChatModel.fromMap(doc.data());
              UserModel? user = users[homeUser.userId];
              return user != null
                  ? HomeChatModel(
                      name: user.name,
                      lastMessage: homeUser.lastMessage,
                      profilePic: user.profilePic,
                      timeSent: homeUser.timeSent,
                      userId: user.uid,
                    )
                  : null;
            })
            .whereType<HomeChatModel>()
            .toList();

        stopwatch.stop(); // Stop the stopwatch
        print('Time taken to fetch chats: ${stopwatch.elapsedMilliseconds} ms');

        return homeChats;
      } catch (e) {
        print('Error fetching chats: $e');
        stopwatch.stop(); // Ensure stopwatch is stopped even in case of error
        print('Time taken to fetch chats: ${stopwatch.elapsedMilliseconds} ms');
        return [];
      }
    });
  }

  Stream<List<MessageModel>> getChats(String receiverId) {
    return fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .map((collection) {
      print(collection.docs.length);
      List<MessageModel> messages = [];
      for (var msg in collection.docs) {
        messages.add(MessageModel.fromMap(msg.data()));
      }
      return messages;
    });
  }
}
