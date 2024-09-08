import 'dart:developer';

import 'package:chat_app_flutter/features/home/model/home_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/authentication_screen/model/user_model.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static UserModel? currentUserData;
  static UserModel? receiverUserData;

  Future<void> saveUserData(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      currentUserData = user;
      return user;
    }
    return null;
  }

  Future<List<UserModel>> getAllUsersExcludingLoggedIn(
      String loggedInUserId) async {
    // Assume a `userCollection` is a reference to the users collection
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: loggedInUserId)
        .get();
    print('Users retrieved: ${querySnapshot.docs.map((doc) => doc.data())}');

    return querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> getReceiverData(String receiverId) async {
    final receiverData = await _db.collection("users").doc(receiverId).get();
    receiverUserData = UserModel.fromMap(receiverData.data()!);
  }

  Future<void> updateIsOnline(bool isOnline) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _db.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserModel> getUserDataById(String uid) {
    return _db
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((e) => UserModel.fromMap(e.data()!));
  }

  Future<void> updateProfile(String uid, String image) async {
    log("updateProfile : $uid");
    log("updateProfile : $image");
    await _db.collection("users").doc(uid).update({'profilePic': image});
    log("image updated");
    currentUserData?.copyWith(profilePic: image);
  }

  Future<void> updateUserData(String uid, String image, String name) async {
    log("updateProfile : $uid");
    log("updateProfile : $image");
    await _db
        .collection("users")
        .doc(uid)
        .update({'profilePic': image, 'name': name});
    log("user updated");
  }

  // Method to get the reference to the chat document in Firestore
  DocumentReference getChatDocRef(String receiverId, String userId) {
    return _db
        .collection('users')
        .doc(receiverId) // receiver's id
        .collection('chats')
        .doc(userId); // current user's id
  }

  Future<List<HomeChatModel>> getUserChats(String uid) async {
    var chatSnapshots =
        await _db.collection('users').doc(uid).collection('chats').get();

    return chatSnapshots.docs
        .map((doc) => HomeChatModel.fromMap(doc.data()))
        .toList();
  }
}
