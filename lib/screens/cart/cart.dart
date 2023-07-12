import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/screens/cart/widget/item_cart.dart';
import 'package:saleshoppingapp/screens/payment/payment.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import '../../constant/routes.dart';
import '../../provider/app_provider.dart';
import '../../widgets/button/primary_button.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final formatter = NumberFormat('#,###', 'en_US');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            title: Text(
              getString(context, 'title_cart'),
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            actions: const [
              Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30,
              )
            ],
            elevation: 5,
          ),
          Expanded(
              flex: 1,
              child: provider.cartList.isEmpty
                  ? Center(
                      child: Text(
                        getString(context, 'message_list_cart_empty'),
                        style: TextStyle(
                            color: ColorInstance.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: provider.cartList.length,
                      itemBuilder: (context, index) {
                        final carts = provider.cartList[index];
                        return ItemCart(products: carts);
                      },
                    )),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getString(context,'txt_total'),
                      style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${formatter.format(provider.totalPrice())}đ',
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                PrimaryButton(
                    onPressed: () {
                      // if(provider.cartList.isEmpty){
                      //   showMessage(getString(context, 'message_list_cart_empty'));
                      // }else{
                        Routes.instance
                            .push(widget: Payment(), context: context);
                   //   }
                    }, title: getString(context, 'btn_order')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
