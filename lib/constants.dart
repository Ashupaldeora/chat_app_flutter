import 'package:chat_app_flutter/features/home/model/home_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
