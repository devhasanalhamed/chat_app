import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService();

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    try {
      final Reference fileRef = _firebaseStorage
          .ref('users/profiles')
          .child('$uid${path.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);
      return task.then((profile) {
        if (profile.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
        return null;
      });
    } catch (e) {
      debugPrint('upload file error: $e');
    }
    return null;
  }
}
