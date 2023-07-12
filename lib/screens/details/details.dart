import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/models/product.dart';
import 'package:saleshoppingapp/screens/details/widgets/details_app_bar.dart';
import 'package:intl/intl.dart';
import '../../constant/routes.dart';
import '../../provider/app_provider.dart';
import '../cart/cart.dart';

class DetailsProduct extends StatefulWidget {
  final Product products;

  const DetailsProduct({required this.products});

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  final formatter = NumberFormat('#,###', 'en_US');
  int number = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFD0FFF4),
      body: SafeArea(
        child: Column(
          children: [
            DetailsAppBar(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(widget.products.ImageProduct, height: 240),
            ),
            Expanded(
              flex: 1,
              child: Arc(
                  edge: Edge.TOP,
                  arcType: ArcType.CONVEY,
                  height: 30,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CupertinoButton(
                                          child: const CircleAvatar(
                                            maxRadius: 15,
                                            backgroundColor: Colors.teal,
                                            child: Icon(
                                              Icons.remove,
                                              size: 23,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (number > 1) {
                                              setState(() {
                                                number--;
                                              });
                                            }
                                          }),
                                      Text(
                                        number.toString(),
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.teal),
                                      ),
                                      CupertinoButton(
                                        child: const CircleAvatar(
                                          maxRadius: 15,
                                          backgroundColor: Colors.teal,
                                          child: Icon(
                                            Icons.add,
                                            size: 23,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            number++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.products.NameProduct,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const Spacer(),
                                    provider.isExits(widget.products)
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 28,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${formatter.format(double.parse(widget.products.PriceProduct))}đ',
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text(
                                  getString(context, 'txt_product_description'),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Text(
                                widget.products.DescriptionProduct,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    wordSpacing: 2),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Product productNew = widget.products
                                      .copyWith(numberOrder: number);
                                  provider.addCartProduct(productNew, number);
                                  Routes.instance
                                      .push(widget: Cart(), context: context);
                                },
                                icon: const Icon(Icons.payment),
                                label: Text(
                                  getString(context, 'txt_buy_now'),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.teal),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Product productNew = widget.products
                                      .copyWith(numberOrder: number);
                                  provider.addCartProduct(productNew, number);
                                  showMessage(getString(
                                      context, 'message_add_to_cart_success'));
                                },
                                icon:
                                    const Icon(CupertinoIcons.cart_badge_plus),
                                label: Text(
                                  getString(context, 'txt_add_to_cart'),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.teal),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
