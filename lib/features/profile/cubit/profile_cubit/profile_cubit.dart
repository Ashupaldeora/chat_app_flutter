import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/services/firebase_storage/storage_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constants.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
            imageUrl: FireStoreService.currentUserData!.profilePic,
            imageFile: null,
            name: FireStoreService.currentUserData!.name));

  Future<void> pickImagePressed() async {
    File? image = await pickImage();
    if (image != null) {
      return emit(ProfileState(
          imageFile: image,
          imageUrl: FireStoreService.currentUserData!.profilePic));
    }
  }

  Future<void> setProfilePicture() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String url = await StorageServices.storageServices
        .uploadProfilePictureToStorage(state.imageFile!, "profile/$uid");
    await FireStoreService().updateProfile(uid, url);
    // Fetch all the chats the user has been involved in
    var chats = await FireStoreService().getUserChats(uid);

    // Start a Firestore batch
    var batch = FirebaseFirestore.instance.batch();

    // For each chat, update the user's profile picture in the receiver's chat document
    for (var chat in chats) {
      var receiverId = chat.userId;
      var chatDocRef = FireStoreService().getChatDocRef(receiverId, uid);
      // Add an update operation to the batch for each chat document
      batch.update(chatDocRef, {'profilePic': url});
    }
    // Commit the batch write (this will update all chat documents in one go)
    await batch.commit();
    return emit(ProfileState(imageUrl: url, imageFile: state.imageFile!));
  }

  // fetching user data for displaying at profile page
  Future<void> fetchUserProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // Fetch user data from FireStore
    UserModel? user = await FireStoreService().getUserData(uid);

    String profilePic = user!.profilePic;
    String name = user.name;
    // Emit the new state with fetched data
    emit(ProfileState(imageUrl: profilePic, imageFile: null, name: name));
  }

  Future<void> updateUser(String name) async {
    emit(ProfileLoading());
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (name == state.name && state.imageFile == null) {
      // No changes made, simply return

      return;
    }
    try {
      String url = await StorageServices.storageServices
          .uploadProfilePictureToStorage(state.imageFile!, "profile/$uid");
      await FireStoreService().updateUserData(
        uid,
        url,
        name,
      );

      var chats = await FireStoreService().getUserChats(uid);

      // Start a Firestore batch
      var batch = FirebaseFirestore.instance.batch();

      // For each chat, update the user's profile picture in the receiver's chat document
      for (var chat in chats) {
        var receiverId = chat.userId;
        var chatDocRef = FireStoreService().getChatDocRef(receiverId, uid);
        // Add an update operation to the batch for each chat document
        batch.update(chatDocRef, {'profilePic': url, 'name': name});
      }
      // Commit the batch write (this will update all chat documents in one go)
      await batch.commit();
      // Emit success state with updated data
      return emit(ProfileUpdateSuccess(
          imageUrl: url, imageFile: state.imageFile, name: name));
    } catch (e) {
      return emit(ProfileUpdateFailure(e.toString()));
    }
  }

  @override
  void onChange(Change<ProfileState> change) {
    // TODO: implement onChange
    log("profile cubit: ${change.nextState.imageUrl}");
    super.onChange(change);
  }
}
