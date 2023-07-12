// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/firebase_helper/firestore_database/firebase_firestore.dart';
import 'package:saleshoppingapp/models/product.dart';
import 'package:saleshoppingapp/models/user.dart';
import '../models/notification.dart';
import '../share_preferences/app_shared_preferences.dart';

class AppProvider with ChangeNotifier {
  final List<Product> _favoriteProductList = [];
  final List<Product> _cartProductList = [];
  final List<Product> _categoriesList = [];
  final List<NotificationModel> _notificationList = [];
  Users? _users;

  Users get getUserInformation => _users!;

  List<Product> get favoriteList => _favoriteProductList;

  List<Product> get cartList => _cartProductList;

  List<Product> get categoryList => _categoriesList;

  List<NotificationModel> get notificationList => _notificationList;

  late Locale _locale = const Locale("en");

  Locale get locale => _locale;

  AppProvider() {
    initLocale();
  }

  initLocale() async {
    Locale appLocale = await AppSharedPreferences().getLocale();
    _locale = appLocale;
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    _locale = locale;
    await AppSharedPreferences().setLocale(locale.languageCode);
    notifyListeners();
  }

  //Favorite
  void addFavoriteProduct(Product product) {
    final isExits = _favoriteProductList.contains(product);
    if (isExits) {
      _favoriteProductList.remove(product);
    } else {
      _favoriteProductList.add(product);
    }
    notifyListeners();
  }

  bool isExits(Product product) {
    final isExits = _favoriteProductList.contains(product);
    return isExits;
  }

  //Cart
  void addCartProduct(Product product, int number) {
    if (_cartProductList.isNotEmpty) {
      var exists = false;
      for (int i = 0; i < _cartProductList.length; i++) {
        if (_cartProductList[i].IdProduct.contains(product.IdProduct)) {
          _cartProductList[i].numberOrder =
              (_cartProductList[i].numberOrder! + number);
          exists = true;
        }
      }
      if (!exists) {
        _cartProductList.add(product);
      }
    } else {
      _cartProductList.add(product);
    }
    notifyListeners();
  }

  void removeCartProduct(Product product) {
    _cartProductList.remove(product);
    notifyListeners();
  }
  void cleanCart(){
    _cartProductList.clear();
    notifyListeners();
  }
  double sumPrice(Product products) {
    double sumPrice = 0.0;
    sumPrice += double.parse(products.PriceProduct) * products.numberOrder!;
    return sumPrice;
  }

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += double.parse(element.PriceProduct) * element.numberOrder!;
    }
    return totalPrice;
  }

  void updateNumber(Product products, int number) {
    int index = _cartProductList.indexOf(products);
    _cartProductList[index].numberOrder = number;
    sumPrice(products);
    notifyListeners();
  }

  //Notification
  void addNotification(NotificationModel notifications){
    _notificationList.add(notifications);
    notifyListeners();
  }
  void removeNotification(NotificationModel notifications){
    _notificationList.remove(notifications);
    notifyListeners();
  }
  //User information
  void getUserFromFirestore() async {
    _users = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFireStore(BuildContext context, Users users) async {
    showLoaderDialog(context);
    _users = users;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_users!.idUser)
        .set(_users!.toJson());
    Navigator.of(context).pop();
    showMessage(getString(context, 'message_update_profile_success'));
    notifyListeners();
  }

  void uploadAvatar(BuildContext context, Users users) async {
    _users = users;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_users!.idUser)
        .set(_users!.toJson());
    showMessage(getString(context, 'upload_avatar_success'));
    notifyListeners();
  }

  void updatePasswordFireStore(Users users) async {
    _users = users;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_users!.idUser)
        .set(_users!.toJson());
    notifyListeners();
  }
}
