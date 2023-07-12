import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/screens/home/widgets/appbar.dart';
import 'package:saleshoppingapp/screens/home/widgets/categories.dart';
import 'package:saleshoppingapp/screens/home/widgets/list_item_product.dart';
import '../../constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:saleshoppingapp/constant/utils.dart';
import '../../constant/constants.dart';
import '../../models/product.dart';
import '../../provider/app_provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController edtSearch = TextEditingController();
  bool _loading = false;
  List<Product> productList = [];
  List<Product> searchList = [];

  Future<void> fetDataProduct() async {
    setState(() {
      _loading = true;
    });
    const url =
        'https://tranvanhau2001.000webhostapp.com/Server/getproduct.php';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      final results = json['results'] as List<dynamic>;
      setState(() {
        productList = results.map((data) => Product.fromJson(data)).toList();
        Utils.instance.productLists = productList;
        _loading = false;
      });
    } else {
      throw Exception(getString(context, 'txt_failed_fetch_data'));
    }
  }

  void searchProducts(String value) {
    searchList = productList
        .where((element) =>
            element.NameProduct.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserFromFirestore();
    if (Utils.instance.productLists.isNotEmpty) {
      productList = Utils.instance.productLists;
      _loading = false;
    } else {
      fetDataProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //App bar
            AppBarHome(),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: edtSearch,
                onChanged: (String value) {
                  searchProducts(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 25),
                  hintText: getString(context, 'edt_search'),
                  hintStyle: TextStyle(color: ColorInstance.backgroundColor),
                ),
                textAlignVertical: TextAlignVertical.bottom,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              getString(context, 'txt_categories'),
              style: TextStyle(
                color: ColorInstance.backgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Handle',
              ),
            ),
            //Categories
            CategoryWidget(),
            const SizedBox(height: 15),
            Text(
              getString(context, 'txt_best_selling'),
              style: TextStyle(
                color: ColorInstance.backgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Handle',
              ),
            ),
            //List item
            edtSearch.text.isNotEmpty && searchList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        getString(context, 'edt_search_not_found'),
                        style: TextStyle(
                            color: ColorInstance.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : searchList.isNotEmpty
                    ? ListItemProduct(
                        loading: _loading, productList: searchList)
                    : ListItemProduct(
                        loading: _loading, productList: productList)
          ],
        ),
      ),
    ]);
  }
}
