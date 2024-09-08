import 'dart:developer';
import 'dart:io';

import 'package:chat_app_flutter/features/home/model/home_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'features/profile/cubit/profile_cubit/profile_cubit.dart';

class Constants {
  static const String defaultProfileImage =
      "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png";
}

void snackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.blue,
      // Customize the background color
      behavior: SnackBarBehavior.floating,
      // Makes the SnackBar floating
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10), // Set corners to 0 for square shape
      ),
      margin: const EdgeInsets.all(16), // Add margin to make it floating
    ),
  );
}

List<String> generateSearchKeywords(String name) {
  List<String> keywords = [];
  String current = "";
  for (var char in name.toLowerCase().split('')) {
    current += char;
    keywords.add(current);
  }
  return keywords;
}

Future<List<HomeChatModel>> searchUsers(String query) async {
  // Convert the query to lowercase
  String lowercaseQuery = query.toLowerCase();

  // Query Firestore for users where searchableKeywords contains the query
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('searchableKeywords', arrayContains: lowercaseQuery)
      .get();

  // Convert query results to a list of User objects
  return snapshot.docs
      .map((doc) => HomeChatModel.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
}

String capitalizeWords(String str) {
  if (str.isEmpty) return str;

  // Split the string into individual words
  List<String> words = str.split(' ');

  // Capitalize the first letter of each word and join them back together
  String capitalized = words.map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');

  return capitalized;
}

void showProfileDialog(BuildContext context) {
  showGeneralDialog(
    context: context,

    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    // Dim the background
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeIn),
            ),
            child: AlertDialog(
              title: Text(
                "Change Profile Picture",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return CircleAvatar(
                            radius: 60.r,
                            backgroundImage: state.imageFile != null
                                ? FileImage(state.imageFile!) as ImageProvider
                                : NetworkImage(state.imageUrl!),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: -10.w,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            context.read<ProfileCubit>().pickImagePressed();
                          },
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Later",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color(0xffD227A9), fontSize: 13.sp),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ProfileCubit>().setProfilePicture();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Set",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color(0xffD227A9), fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      );
    },
  );
}

Future<File?> pickImage() async {
  File? image;
  XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  try {
    if (xFile != null) {
      image = File(xFile.path);
    }
  } catch (e) {
    log(e.toString());
  }
  return image;
}
