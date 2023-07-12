// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/models/user.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      BuildContext context, String email, String password) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop(); //an dialog
      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
      Navigator.of(context).pop();
      return false;
    }
  }

  Future<bool> signup(BuildContext context, String email, String password,
      String name, String phone) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      Users users = Users(
          idUser: userCredential.user!.uid,
          name: name,
          email: email,
          avatar: null,
          phone: phone,
          passWord: password);
      _firestore.collection("users").doc(users.idUser).set(users.toJson());
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
      Navigator.of(context).pop();
      return false;
    }
  }

  Future<bool> forgotPassword(BuildContext context, String email) async {
    try {
      showLoaderDialog(context);
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
      Navigator.of(context).pop();
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(BuildContext context, String newPassword) async {
    try {
      showLoaderDialog(context);
      await _auth.currentUser!.updatePassword(newPassword);
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
      Navigator.of(context).pop();
      return false;
    }
  }
}
