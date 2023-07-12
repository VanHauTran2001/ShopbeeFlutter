import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/models/message_model.dart';
import 'package:saleshoppingapp/models/user.dart';

import '../../models/order.dart';
import '../../models/product.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Users> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return Users.fromJson(querySnapshot.data()!);
  }

  Future<bool> addOrderProductToFirebase(
      BuildContext context,
      String name,
      String phone,
      String address,
      String payment,
      String status,
      String dateOrder,
      double totalPrice,
      List<Product> list) async {
    try {
      showLoaderDialog(context);
      DocumentReference documentReferences = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      documentReferences.set({
        "orderID": documentReferences.id,
        "nameUser": name,
        "phoneUser": phone,
        "addressUser": address,
        "totalPrice": totalPrice,
        "payment": payment,
        "status": status,
        "dateOrder": dateOrder,
        "products": list.map((e) => e.toJson())
      });
      Navigator.of(context).pop();
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context).pop();
      return false;
    }
  }

  //Get user order
  Future<List<OrderModel>> getPurchasedOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();
      List<OrderModel> orderList =
          querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();
      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  //Get list user
  Future<List<Users>> getListUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("users").get();
      List<Users> usersList =
          querySnapshot.docs.map((e) => Users.fromJson(e.data())).toList();
      List<Users> newList = usersList
          .where(
              (user) => user.idUser != FirebaseAuth.instance.currentUser!.uid)
          .toList();
      return newList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }
}
