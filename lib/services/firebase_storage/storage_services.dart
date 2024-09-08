import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  static final StorageServices storageServices = StorageServices._();

  StorageServices._();

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfilePictureToStorage(File image, String path) async {
    UploadTask task = firebaseStorage.ref().child(path).putFile(image);
    TaskSnapshot taskSnapshot = await task;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
