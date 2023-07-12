import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constant/color.dart';
import 'package:http/http.dart' as http;
import '../../constant/constants.dart';
import '../../constant/routes.dart';
import '../../models/product.dart';
import '../../provider/app_provider.dart';
import '../details/details.dart';

class Category_Screen extends StatefulWidget {
  String type;
  String name;
  Category_Screen({required this.type, required this.name});

  @override
  State<Category_Screen> createState() => _CategoryState();
}

class _CategoryState extends State<Category_Screen> {
  final formatter = NumberFormat('#,###', 'en_US');
  bool _loading = false;
  List<Product> productList = [];
  int number = 1;

  Future<void> postDataProduct() async {
    setState(() {
      _loading = true;
    });
    const url = 'https://tranvanhau2001.000webhostapp.com/Server/getloai.php';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: {'TypeProduct': widget.type});
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      final results = json['results'] as List<dynamic>;
      setState(() {
        productList = results.map((data) => Product.fromJson(data)).toList();
        _loading = false;
      });
    } else {
      throw Exception(getString(context, 'txt_failed_fetch_data'));
    }
  }

  @override
  void initState() {
    super.initState();
    postDataProduct();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            title: Text(
              widget.name,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            elevation: 5,
          ),
          Expanded(
              flex: 1,
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ColorInstance.backgroundColor),
                    )
                  : productList.isEmpty
                      ? Center(
                          child: Text(
                            getString(context, 'message_list_category_empty'),
                            style: TextStyle(
                                color: ColorInstance.backgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(5),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                    left: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.teal,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(
                                                  '-${products.sale}%',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  provider.addFavoriteProduct(
                                                      products);
                                                },
                                                child: provider
                                                        .isExits(products)
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
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
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
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${formatter.format(double.parse(products.PriceProduct))}đ',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    Product productNew =
                                                        products.copyWith(
                                                            numberOrder:
                                                                number);
                                                    provider.addCartProduct(
                                                        productNew, number);
                                                    showMessage(getString(
                                                        context,
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
