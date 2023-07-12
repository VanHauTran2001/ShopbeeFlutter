import 'package:saleshoppingapp/models/product.dart';

class OrderModel {
  String orderID;
  String nameUser;
  String phoneUser;
  String addressUser;
  double totalPrice;
  String payment;
  String status;
  String dateOrder;
  List<Product> listProducts;

  OrderModel(
      {required this.orderID,
      required this.nameUser,
      required this.phoneUser,
      required this.addressUser,
      required this.totalPrice,
      required this.payment,
      required this.status,
      required this.dateOrder,
      required this.listProducts});
  factory OrderModel.fromJson(Map<String,dynamic> json){
    List<dynamic> products = json['products'];
    return OrderModel(
        orderID: json['orderID'],
        nameUser: json['nameUser'],
        phoneUser: json['phoneUser'],
        addressUser: json['addressUser'],
        totalPrice: json['totalPrice'],
        payment: json['payment'],
        status: json['status'],
        dateOrder: json['dateOrder'],
        listProducts: products.map((e) => Product.fromJson(e)).toList()
    );
}
}
