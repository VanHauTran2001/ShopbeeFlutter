import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saleshoppingapp/firebase_helper/firestore_database/firebase_firestore.dart';
import 'package:saleshoppingapp/models/order.dart';
import 'package:saleshoppingapp/models/product.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';


class PurchasedOrder extends StatefulWidget {
  @override
  State<PurchasedOrder> createState() => _PurchasedOrderState();
}

class _PurchasedOrderState extends State<PurchasedOrder> {
  final formatter = NumberFormat('#,###', 'en_US');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorInstance.backgroundColor,
        title: Text(
          getString(context, 'type_purchased'),
          style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Handle'),
        ),
        elevation: 5,
      ),
      body: StreamBuilder(
        stream: Stream.fromFuture(
            FirebaseFirestoreHelper.instance.getPurchasedOrder()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: ColorInstance.backgroundColor),
            );
          }
          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              !snapshot.hasData) {
            return Center(
              child: Text(
                getString(context, 'txt_purchased_order_not_found'),
                style: TextStyle(
                    color: ColorInstance.backgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15.0,top: 15,bottom: 15),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  OrderModel orderModel = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorInstance.backgroundColor,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width*0.925,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                              color: ColorInstance.backgroundColor
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.qr_code_scanner,color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    orderModel.orderID,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${getString(context, 'edt_name')} :',
                                        style: TextStyle(
                                          color: ColorInstance.backgroundColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Handle'
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        orderModel.nameUser,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${getString(context, 'edt_phone')} :',
                                        style: TextStyle(
                                            color: ColorInstance.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Handle'
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        orderModel.phoneUser,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${getString(context, 'edt_address')} :',
                                        style: TextStyle(
                                            color: ColorInstance.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Handle'
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        orderModel.addressUser,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${getString(context, 'txt_payment')} :',
                                        style: TextStyle(
                                            color: ColorInstance.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Handle'
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        orderModel.payment,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${getString(context, 'txt_status')} :',
                                        style: TextStyle(
                                            color: ColorInstance.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Handle'
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        orderModel.status,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        getString(context, 'txt_list_of_product'),
                                        style: TextStyle(
                                            color: ColorInstance.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Handle'
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(child:  SizedBox(
                                    width: double.infinity,
                                    height: 300,
                                    child: ListView.builder(
                                        itemCount: orderModel.listProducts.length,
                                        itemBuilder: (context,index){
                                          Product products = orderModel.listProducts[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorInstance.backgroundColor,
                                                    width: 2
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              width: double.infinity,
                                              height: 115,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Image.network(
                                                      products.ImageProduct,
                                                      width: 80,
                                                      height: 90,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 8,right: 8,bottom: 8),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              products.NameProduct,
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black
                                                              ),
                                                              maxLines: 2,
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              '${formatter.format(double.parse(products.PriceProduct))}đ',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.black
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              'x ${products.numberOrder}',
                                                              style: const TextStyle(
                                                                  fontSize: 19,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ),),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 65,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              getString(context, 'txt_date'),
                                              style: TextStyle(
                                                  color: ColorInstance.backgroundColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Handle'
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              orderModel.dateOrder,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              getString(context, 'txt_total_payment'),
                                              style: TextStyle(
                                                  color: ColorInstance.backgroundColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Handle'
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${formatter.format(orderModel.totalPrice)}đ',
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
