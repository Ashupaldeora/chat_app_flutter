import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/services/firebase_storage/storage_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
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
    String url = await StorageServices.storageServices
        .uploadProfilePictureToStorage(state.imageFile!, "profile/$uid");
    await FireStoreService().updateUserData(
      uid,
      url,
      name,
    );
    return emit(
        ProfileState(imageUrl: url, imageFile: state.imageFile!, name: name));
  }

  @override
  void onChange(Change<ProfileState> change) {
    // TODO: implement onChange
    log("profile cubit: ${change.nextState.imageUrl}");
    super.onChange(change);
  }
}
