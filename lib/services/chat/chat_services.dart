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

      String messageId = const Uuid().v1();
      var time = DateTime.now();
      final receiverModel = FireStoreService.receiverUserData;

      await Future.wait([
        _saveMessageToSubCollection(
          senderId: sender.uid,
          receiverId: receiverId,
          message: message,
          messageId: messageId,
          timeSent: time,
        ),
        _saveLastSendMessage(
          receiver: receiverModel!,
          sender: sender,
          lastMessage: message,
          timeSent: time,
        ),
      ]);

      stopwatch.stop();
      print('sendTextMessage duration: ${stopwatch.elapsedMilliseconds}ms');
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
          timeSent: timeSent,
          isSeen: false);

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
        userId: receiver.uid,
        numberOfNotSeenMessages: 0);
    // created a homeChatModel of receiver with received parameter(receiver will see sender data on home screen)

    HomeChatModel receiverData = HomeChatModel(
        name: sender.name,
        lastMessage: lastMessage,
        profilePic: sender.profilePic,
        timeSent: timeSent,
        userId: sender.uid,
        numberOfNotSeenMessages: 0);

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

  // Stream<List<HomeChatModel>> getHomeChats() {
  //   return fireStore
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection(
  //         "chats",
  //       )
  //       .orderBy("timeSent", descending: true)
  //       .snapshots()
  //       .asyncMap((collection) async {
  //     final stopwatch = Stopwatch()..start(); // Start the stopwatch
  //     /** what does this function do in short :-
  //      * Basically we are getting data to be shown on home screen
  //      * in chats collection where data of the home screen rests
  //      * */
  //     try {
  //       //Directly convert each chat document to HomeChatModel
  //
  //       List<HomeChatModel> homeChats =
  //           await Future.wait(collection.docs.map((doc) async {
  //         // Fetch the number of unseen messages for each chat
  //         int numberOfMessagesNotSeen =
  //             await _getNumberOfUnseenMessages(doc.id);
  //         fireStore
  //             .collection("users")
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .collection(
  //               "chats",
  //             )
  //             .doc(doc.id)
  //             .update({"numberOfNotSeenMessages": numberOfMessagesNotSeen});
  //         print(doc.data());
  //         return HomeChatModel.fromMap(doc.data()).copyWith(
  //           numberOfNotSeenMessages: numberOfMessagesNotSeen,
  //         );
  //       }).toList());
  //       return homeChats;
  //     } catch (e) {
  //       print('Error fetching chats: $e');
  //       return [];
  //     }
  //   });
  // }

  Stream<List<HomeChatModel>> getHomeChats() {
    final stopwatch = Stopwatch()..start();

    return fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .orderBy("timeSent", descending: true)
        .snapshots()
        .asyncMap((collection) async {
      try {
        List<HomeChatModel> homeChats =
            await Future.wait(collection.docs.map((doc) async {
          // Fetch the number of unseen messages for each chat
          int numberOfMessagesNotSeen =
              await _getNumberOfUnseenMessages(doc.id);
          fireStore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(
                "chats",
              )
              .doc(doc.id)
              .update({"numberOfNotSeenMessages": numberOfMessagesNotSeen});
          log("number of unseen messages: $numberOfMessagesNotSeen");
          return HomeChatModel.fromMap(doc.data());
        }).toList());
        stopwatch.stop();

        return homeChats;
      } catch (e) {
        log("${e}this is home chat error");
      }
      return [];
    });
  }

  Future<int> _getNumberOfUnseenMessages(String receiverId) async {
    int unreadMessages = 0;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var collection = await fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .where("isSeen", isEqualTo: false)
        .get();
    for (var doc in collection.docs) {
      if (doc.data()['receiverId'] == currentUserId) {
        unreadMessages++;
      }
    }
    return unreadMessages;
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
      List<MessageModel> messages = [];
      for (var msg in collection.docs) {
        messages.add(MessageModel.fromMap(msg.data()));
      }
      return messages;
    });
  }

  Future<void> updateChatIsSeen(String messageId, String receiverId) async {
    WriteBatch batch = fireStore.batch();
    // Define document references
    DocumentReference senderMessageRef = fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId);

    DocumentReference receiverMessageRef = fireStore
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .doc(messageId);

    // Set the data in the batch
    batch.update(senderMessageRef, {'isSeen': true});
    batch.update(receiverMessageRef, {'isSeen': true});

    // Update the number of not seen messages for the sender
    DocumentReference senderChatRef = fireStore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId);
    log("called seen true method");
    batch.update(
        senderChatRef, {'numberOfNotSeenMessages': FieldValue.increment(-1)});
    // Commit the batch
    await batch.commit();
  }

  Future<void> deleteMessage(
      String messageId, String receiverId, bool isSender) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Define document references for message deletion
      DocumentReference senderMessageRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("chats")
          .doc(receiverId)
          .collection("messages")
          .doc(messageId);

      DocumentReference receiverMessageRef = FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(userId)
          .collection("messages")
          .doc(messageId);

      // If the message belongs to the sender, delete from both sender and receiver collections
      if (isSender) {
        batch.delete(senderMessageRef);
        batch.delete(receiverMessageRef);
      } else {
        // If the message belongs to the receiver, only delete it from the sender's collection
        batch.delete(senderMessageRef);
      }

      // Commit the batch first to ensure deletion
      await batch.commit();

      // Now after the deletion, fetch the last messages for both sender and receiver
      final senderLastMessageSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("chats")
          .doc(receiverId)
          .collection("messages")
          .orderBy('timeSent', descending: true)
          .limit(1)
          .get();

      final receiverLastMessageSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(userId)
          .collection("messages")
          .orderBy('timeSent', descending: true)
          .limit(1)
          .get();

      WriteBatch updateBatch = FirebaseFirestore.instance.batch();

      // Define document references for last message updates
      DocumentReference senderChatDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("chats")
          .doc(receiverId);

      DocumentReference receiverChatDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(userId);

      // Update lastMessage for sender
      if (senderLastMessageSnapshot.docs.isNotEmpty) {
        final lastMessage = senderLastMessageSnapshot.docs.first;
        updateBatch.update(senderChatDoc, {
          'lastMessage': lastMessage['message'],
          'lastMessageTime': lastMessage['timeSent'],
        });
      } else {
        // If no messages are left, set default values
        updateBatch.update(senderChatDoc, {
          'lastMessage': 'No messages',
          'lastMessageTime': null,
        });
      }

      // Update lastMessage for receiver only if the deleted message belonged to the sender
      if (isSender) {
        if (receiverLastMessageSnapshot.docs.isNotEmpty) {
          final lastMessage = receiverLastMessageSnapshot.docs.first;
          updateBatch.update(receiverChatDoc, {
            'lastMessage': lastMessage['message'],
            'lastMessageTime': lastMessage['timeSent'],
          });
        } else {
          // If no messages are left, set default values
          updateBatch.update(receiverChatDoc, {
            'lastMessage': 'No messages',
            'lastMessageTime': null,
          });
        }
      }

      // Commit the second batch for updating the last message
      await updateBatch.commit();
    } catch (e) {
      throw Exception("Error deleting message and updating last message: $e");
    }
  }

  Future<void> editMessage({
    required String messageId,
    required String receiverId,
    required String newMessage,
    required bool isSender,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      if (isSender) {
        // If the user is the sender, proceed with editing the message
        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Define document references for message updates
        DocumentReference senderMessageRef = FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("chats")
            .doc(receiverId)
            .collection("messages")
            .doc(messageId);

        DocumentReference receiverMessageRef = FirebaseFirestore.instance
            .collection("users")
            .doc(receiverId)
            .collection("chats")
            .doc(userId)
            .collection("messages")
            .doc(messageId);

        // Update the message content for both sender and receiver
        Map<String, dynamic> updatedMessageData = {
          'message': newMessage,
        };

        batch.update(senderMessageRef, updatedMessageData);
        batch.update(receiverMessageRef, updatedMessageData);

        // Commit the batch to update the message
        await batch.commit();
      } else {
        throw Exception("You can only edit your own messages.");
      }
    } catch (e) {
      throw Exception("Error editing message: $e");
    }
  }
}
