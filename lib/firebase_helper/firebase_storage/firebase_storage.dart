import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper{
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async{
    String userID = FirebaseAuth.instance.currentUser!.uid;
    TaskSnapshot taskSnapshot = await _storage.ref(userID).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}