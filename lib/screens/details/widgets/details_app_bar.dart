import 'package:flutter/material.dart';

import 'package:saleshoppingapp/constant/color.dart';
import '../../../constant/constants.dart';
import '../../../constant/routes.dart';
import '../../cart/cart.dart';

class DetailsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: ColorInstance.backgroundColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(getString(context, 'txt_details_product'),
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontFamily: 'Handle')),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Routes.instance.push(widget: Cart(), context: context);
            },
            child: Icon(
              Icons.shopping_cart,
              size: 30,
              color: ColorInstance.backgroundColor,
            ),
          )
        ],
      ),
    );
  }
}
