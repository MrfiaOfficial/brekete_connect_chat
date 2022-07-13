import 'dart:io';
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageFirebase {
  Future<String?> uploadToStorage(String? imagePath) async {
    File file = File(imagePath!);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    try {
      await ref.putFile(file);
      var url = ref.getDownloadURL();
      return url;
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
