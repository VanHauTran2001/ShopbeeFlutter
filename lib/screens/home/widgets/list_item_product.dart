import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/routes.dart';
import 'package:saleshoppingapp/screens/details/details.dart';
import '../../../constant/color.dart';
import '../../../constant/constants.dart';
import '../../../models/product.dart';
import '../../../provider/app_provider.dart';

class ListItemProduct extends StatefulWidget {
  final bool loading;
  final List<Product> productList;

  ListItemProduct({required this.loading, required this.productList});

  @override
  State<ListItemProduct> createState() => _ListItemProductState();
}

class _ListItemProductState extends State<ListItemProduct> {
  final formatter = NumberFormat('#,###', 'en_US');
  int number = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return widget.loading
        ? Center(
            child: Container(
                margin: const EdgeInsets.only(top: 150),
                child: CircularProgressIndicator(
                    color: ColorInstance.backgroundColor)),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              final products = widget.productList[index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(224, 255, 255, 100),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 3),
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  '-${products.sale}%',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  provider.addFavoriteProduct(products);
                                },
                                child: provider.isExits(products)
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
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Routes.instance.push(
                                  widget: DetailsProduct(products: products),
                                  context: context);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Image.network(
                                products.ImageProduct,
                                width: 130,
                                height: 120,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              products.DescriptionProduct,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Text(
                                  '${formatter.format(double.parse(products.PriceProduct))}đ',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Product productNew =
                                        products.copyWith(numberOrder: number);
                                    provider.addCartProduct(productNew, number);
                                    showMessage(getString(context,
                                        'message_add_to_cart_success'));
                                  },
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.teal,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
