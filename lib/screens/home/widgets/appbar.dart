import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/color.dart';

import '../../../constant/constants.dart';
import '../../../constant/routes.dart';
import '../../../provider/app_provider.dart';
import '../../cart/cart.dart';

class AppBarHome extends StatefulWidget {
  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Row(
      children: [
        Icon(
          Icons.sort,
          size: 32,
          color: ColorInstance.backgroundColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            getString(context, 'txt_title_home'),
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColorInstance.backgroundColor,
                fontFamily: 'Handle'),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: badges.Badge(
            badgeContent: Text(
              provider.cartList.isEmpty
                  ? '0'
                  : provider.cartList.length.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.redAccent, padding: EdgeInsets.all(6)),
            child: InkWell(
              onTap: () {
                Routes.instance.push(widget: Cart(), context: context);
              },
              child: Icon(
                Icons.shopping_cart,
                size: 35,
                color: ColorInstance.backgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
