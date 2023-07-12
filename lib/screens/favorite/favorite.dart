import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import '../../constant/routes.dart';
import '../../models/product.dart';
import '../../provider/app_provider.dart';
import '../details/details.dart';

class Favorite extends StatefulWidget {
  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  int number = 1;
  List<Product> productList = [];
  final formatter = NumberFormat('#,###', 'en_US');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    productList = provider.favoriteList;
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              getString(context, 'title_favorite_list'),
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            actions: [Lottie.asset('assets/json/favorite.json', height: 50)],
            elevation: 5,
          ),
          Expanded(
              flex: 1,
              child: productList.isEmpty
                  ? Center(
                      child: Text(
                        getString(context, 'message_list_favorite_empty'),
                        style: TextStyle(
                            color: ColorInstance.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.63,
                        ),
                        itemBuilder: (context, index) {
                          final products = productList[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          224, 255, 255, 100),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            margin:
                                                const EdgeInsets.only(left: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.teal,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
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
                                              provider
                                                  .addFavoriteProduct(products);
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
                                              widget: DetailsProduct(
                                                  products: products),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          products.DescriptionProduct,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
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
                                                    products.copyWith(
                                                        numberOrder: number);
                                                provider.addCartProduct(
                                                    productNew, number);
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
                      ),
                    )),
        ],
      ),
    );
  }
}
