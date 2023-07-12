import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/color.dart';
import 'package:saleshoppingapp/models/product.dart';
import '../../../constant/constants.dart';
import '../../../provider/app_provider.dart';

class ItemCart extends StatefulWidget {
  final Product products;

  ItemCart({required this.products});

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  final formatter = NumberFormat('#,###', 'en_US');
  int number = 1;

  @override
  void initState() {
    number = widget.products.numberOrder ?? 1;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 5,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  widget.products.ImageProduct,
                  width: 85,
                  height: 85,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.products.NameProduct,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.TOPSLIDE,
                                showCloseIcon: true,
                                title: getString(context, 'txt_confirm'),
                                desc: getString(
                                    context, 'message_confirm_delete'),
                                btnCancelOnPress: () {},
                                btnCancelText:
                                    getString(context, 'dialog_cancel'),
                                btnOkText: getString(context, 'dialog_ok'),
                                btnOkOnPress: () {
                                  provider.removeCartProduct(widget.products);
                                },
                                btnOkColor: ColorInstance.backgroundColor,
                              ).show();
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 23,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${formatter.format(double.parse(widget.products.PriceProduct))}đ',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (number > 1) {
                              setState(() {
                                number--;
                              });
                              provider.updateNumber(widget.products, number);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 10)
                                ]),
                            child: const Icon(
                              CupertinoIcons.minus,
                              size: 18,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              number++;
                            });
                            provider.updateNumber(widget.products, number);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 10)
                                ]),
                            child: const Icon(
                              CupertinoIcons.plus,
                              size: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '${formatter.format(provider.sumPrice(widget.products))}đ',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
